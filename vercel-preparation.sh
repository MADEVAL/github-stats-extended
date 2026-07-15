#!/bin/bash

# defensive error handling
set -euo pipefail

# move into the folder of this script
cd "$(dirname "$0")"

mkdir -p apps/backend/.vercel/output/functions/api.func/
# copying `backend` to `backend/.vercel/...` directly may cause problems
cp -RP apps/backend/. apps/backend-copy/
# `shopt` includes dot-files in the `mv` operation
(shopt -s dotglob && mv apps/backend-copy/* apps/backend/.vercel/output/functions/api.func/)

# replace workspace symlink with actual core build output
rm -rf apps/backend/.vercel/output/functions/api.func/node_modules/@stats-organization
mkdir -p apps/backend/.vercel/output/functions/api.func/node_modules/@stats-organization/github-readme-stats-core
cp -RP packages/core/build/. apps/backend/.vercel/output/functions/api.func/node_modules/@stats-organization/github-readme-stats-core/
cp packages/core/package.json apps/backend/.vercel/output/functions/api.func/node_modules/@stats-organization/github-readme-stats-core/

cp -RP apps/backend/.vercel/output/functions/api.func/_dot_vercel_copy/output apps/backend/.vercel/

# remove empty sub-function directories that intercept routes
find apps/backend/.vercel/output/functions/api -name "*.func" -type d -exec rm -rf {} + 2>/dev/null || true

rm -rf apps/deployment
pnpm install
pnpm build:frontend
mkdir -p apps/backend/.vercel/output/static/frontend/
cp -RP apps/frontend/build/. apps/backend/.vercel/output/static/frontend/
