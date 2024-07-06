#!/bin/bash

set -e

# Verificar que el directorio dist/apps/my-mfe existe
if [ ! -d "dist/apps/my-mfe" ]; then
  echo "Build directory not found!"
  exit 1
fi

cd dist/apps/my-mfe

# Sync bundles with strong cache
aws s3 sync ./static/css s3://$S3_ORIGIN_BUCKET/static/css --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --delete
aws s3 sync ./static/js s3://$S3_ORIGIN_BUCKET/static/js --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --delete

# Sync HTML and other files with no cache
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET --exclude "static/*" --metadata-directive 'REPLACE' --cache-control no-cache,no-store,must-revalidate --delete

echo "Despliegue completado exitosamente."
