import { build } from 'esbuild';
import { readFile } from 'node:fs/promises';

const pkg = JSON.parse(await readFile('node_modules/highcharts/package.json', 'utf8'));
const notice = await readFile('node_modules/highcharts/LICENSE.txt', 'utf8');
await build({
  entryPoints: ['entry.js'],
  outfile: '../../inst/htmlwidgets/lib/highcharter-bundle.js',
  bundle: true,
  minify: true,
  format: 'iife',
  platform: 'browser',
  legalComments: 'inline',
  banner: { js: '/*! Highcharts JS v' + pkg.version + ' | (c) Highsoft AS\n' + notice.trim() + '\n*/' }
});
