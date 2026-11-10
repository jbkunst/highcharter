import { build } from 'esbuild';
import { readFile } from 'node:fs/promises';

const pkg = JSON.parse(await readFile('node_modules/highcharts/package.json', 'utf8'));
const manifest = JSON.parse(await readFile('package.json', 'utf8'));
if (pkg.version !== manifest.devDependencies.highcharts) {
  throw new Error('Run npm ci to install the pinned Highcharts version before building.');
}
const notice = await readFile('node_modules/highcharts/LICENSE.txt', 'utf8');
await build({
  entryPoints: ['entry.js'],
  outfile: process.argv[2] ?? '../../inst/htmlwidgets/lib/highcharter-bundle.js',
  bundle: true,
  minify: true,
  format: 'iife',
  platform: 'browser',
  legalComments: 'inline',
  banner: { js: '/*! Highcharts JS v' + pkg.version + ' | (c) Highsoft AS\n' + notice.trim() + '\n*/' }
});
