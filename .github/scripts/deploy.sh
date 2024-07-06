#!/bin/bash

set -e

# Cambia al directorio de salida de la construcción
cd build

# Sync bundles with strong cache
aws s3 sync ./static/css s3://$S3_ORIGIN_BUCKET/static/css --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --delete
aws s3 sync ./static/js s3://$S3_ORIGIN_BUCKET/static/js --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --delete

# Sync HTML and other files with no cache
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET --exclude "static/*" --metadata-directive 'REPLACE' --cache-control no-cache,no-store,must-revalidate --delete

echo "Despliegue completado exitosamente."
