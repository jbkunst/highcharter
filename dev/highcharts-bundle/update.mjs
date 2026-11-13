import { spawnSync } from 'node:child_process';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const bundleDir = dirname(fileURLToPath(import.meta.url));
const version = process.argv[2];

if (!version || !/^[0-9]+\.[0-9]+\.[0-9]+(?:[-+][A-Za-z0-9.+-]+)?$/.test(version)) {
  throw new Error('Usage: npm run update -- 12.6.2');
}

const npm = process.platform === 'win32' ? 'npm.cmd' : 'npm';
const install = spawnSync(
  npm,
  ['install', '--save-dev', '--save-exact', `highcharts@${version}`],
  { cwd: bundleDir, stdio: 'inherit', shell: process.platform === 'win32' }
);
if (install.status !== 0) process.exit(install.status ?? 1);

const compile = spawnSync(
  process.execPath,
  [join(bundleDir, 'build.mjs')],
  { cwd: bundleDir, stdio: 'inherit' }
);
if (compile.status !== 0) process.exit(compile.status ?? 1);
