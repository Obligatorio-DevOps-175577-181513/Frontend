#!/bin/bash

set -e

echo "Checking build directories..."
# Verificar que los directorios dist/apps/catalog y dist/apps/checkout existen
if [ ! -d "dist/apps/catalog" ]; then
  echo "Build directory for catalog not found!"
  ls -l dist/apps
  exit 1
fi

if [ ! -d "dist/apps/checkout" ]; then
  echo "Build directory for checkout not found!"
  ls -l dist/apps
  exit 1
fi

if [ -z "$S3_ORIGIN_BUCKET" ]; then
  echo "Error: S3_ORIGIN_BUCKET is not defined."
  exit 1
fi

echo "Deploying catalog..."
# Desplegar catalog
cd dist/apps/catalog

# Sync files with appropriate cache settings
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/catalog --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --exclude "index.html" --exclude "assets/*"
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/catalog --metadata-directive 'REPLACE' --cache-control no-cache,no-store,must-revalidate --include "index.html" --include "assets/*" --exclude "*"

echo "Deploying checkout..."
# Desplegar checkout
cd ../../checkout

# Sync files with appropriate cache settings
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/checkout --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --exclude "index.html" --exclude "assets/*"
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/checkout --metadata-directive 'REPLACE' --cache-control no-cache,no-store,must-revalidate --include "index.html" --include "assets/*" --exclude "*"

echo "Deploy completed successfully."
