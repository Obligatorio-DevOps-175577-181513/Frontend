#!/bin/bash

set -e

# Verificar que los directorios dist/apps/catalog y dist/apps/checkout existen
if [ ! -d "dist/apps/catalog" ]; then
  echo "Build directory for catalog not found!"
  exit 1
fi

if [ ! -d "dist/apps/checkout" ]; then
  echo "Build directory for checkout not found!"
  exit 1
fi

# Desplegar catalog
cd dist/apps/catalog

# Sync bundles with strong cache
aws s3 sync ./static/css s3://$S3_ORIGIN_BUCKET/catalog/static/css --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --delete
aws s3 sync ./static/js s3://$S3_ORIGIN_BUCKET/catalog/static/js --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --delete

# Sync HTML and other files with no cache
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/catalog --exclude "static/*" --metadata-directive 'REPLACE' --cache-control no-cache,no-store,must-revalidate --delete

# Desplegar checkout
cd ../../checkout