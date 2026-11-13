import { build } from 'esbuild';
import {
  copyFile,
  cp,
  mkdir,
  readFile,
  rm,
  writeFile
} from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const bundleDir = dirname(fileURLToPath(import.meta.url));
const rootDir = join(bundleDir, '..', '..');
const highchartsDir = join(bundleDir, 'node_modules', 'highcharts');
const widgetsDir = join(rootDir, 'inst', 'htmlwidgets');
const baseBundle = join(widgetsDir, 'lib', 'highcharter-bundle.js');
const stockToolsDir = join(widgetsDir, 'lib', 'stock-tools');

const pkg = JSON.parse(await readFile(join(highchartsDir, 'package.json'), 'utf8'));
const manifest = JSON.parse(await readFile(join(bundleDir, 'package.json'), 'utf8'));

if (pkg.version !== manifest.devDependencies.highcharts) {
  throw new Error('Run npm ci to install the pinned Highcharts version before building.');
}

const notice = await readFile(join(highchartsDir, 'LICENSE.txt'), 'utf8');
await build({
  absWorkingDir: bundleDir,
  entryPoints: ['./entry.js'],
  outfile: baseBundle,
  bundle: true,
  minify: true,
  format: 'iife',
  platform: 'browser',
  legalComments: 'inline',
  banner: {
    js: `/*! Highcharts JS v${pkg.version} | (c) Highsoft AS\n${notice.trim()}\n*/`
  }
});
const bundledSource = await readFile(baseBundle, 'utf8');
await writeFile(baseBundle, bundledSource.replace(/[ \t]+$/gm, ''));

const stockScripts = [
  ['indicators', 'indicators-all.js'],
  ['modules', 'drag-panes.js'],
  ['modules', 'annotations-advanced.js'],
  ['modules', 'price-indicator.js'],
  ['modules', 'stock-tools.js']
];
const stockContents = await Promise.all(
  stockScripts.map(parts => readFile(join(highchartsDir, ...parts), 'utf8'))
);
const stockPrelude = [
  `/*! Highcharter Stock Tools for Highcharts JS v${pkg.version} */`,
  'window.HighcharterStockToolsBaseUrl = new URL(".", document.currentScript.src).href;',
  'ResetHighchartsOptions();'
].join('\n');

await rm(stockToolsDir, { recursive: true, force: true });
await mkdir(join(stockToolsDir, 'css', 'stocktools'), { recursive: true });
await mkdir(join(stockToolsDir, 'css', 'annotations'), { recursive: true });
await writeFile(
  join(stockToolsDir, 'highcharter-stock-tools.js'),
  `${stockPrelude}\n${stockContents.join('\n')}\nwindow.HCStockToolsDefaults = $.extend(true, {}, Highcharts.getOptions());\n`
);
await copyFile(
  join(highchartsDir, 'css', 'stocktools', 'gui.css'),
  join(stockToolsDir, 'css', 'stocktools', 'gui.css')
);
await copyFile(
  join(highchartsDir, 'css', 'annotations', 'popup.css'),
  join(stockToolsDir, 'css', 'annotations', 'popup.css')
);
await cp(
  join(highchartsDir, 'gfx', 'stock-icons'),
  join(stockToolsDir, 'gfx', 'stock-icons'),
  { recursive: true }
);

async function updateDependencyVersion(yamlName, dependencyNames) {
  const yamlPath = join(widgetsDir, yamlName);
  const lines = (await readFile(yamlPath, 'utf8')).split(/\r?\n/);
  let currentDependency = null;
  let updates = 0;

  const updated = lines.map(line => {
    const name = line.match(/^\s*- name:\s*(\S+)\s*$/);
    if (name) currentDependency = name[1];
    if (dependencyNames.includes(currentDependency) && /^\s*version:\s*/.test(line)) {
      currentDependency = null;
      updates += 1;
      return line.replace(/version:\s*\S+/, `version: ${pkg.version}`);
    }
    return line;
  });

  if (updates !== dependencyNames.length) {
    throw new Error(`Could not update every Highcharts dependency in ${yamlName}.`);
  }
  await writeFile(yamlPath, updated.join('\n'));
}

await updateDependencyVersion('highchart.yaml', ['highcharts']);
await updateDependencyVersion('highchartzero.yaml', ['highcharts']);
await updateDependencyVersion(
  'highchartstock.yaml',
  ['highcharts', 'highcharts-stock-tools']
);

console.log(`Highcharts ${pkg.version} base and Stock Tools bundles built.`);
