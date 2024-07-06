#!/bin/bash

set -e

echo "S3_ORIGIN_BUCKET is set to: $S3_ORIGIN_BUCKET"

echo "Deploying catalog..."
cd dist/apps/catalog

# Sync files with appropriate cache settings
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/catalog --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --exclude "index.html" --exclude "assets/*"
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/catalog --metadata-directive 'REPLACE' --cache-control no-cache,no-store,must-revalidate --include "index.html" --include "assets/*" --exclude "*"

echo "Deploying checkout..."
cd ../../checkout

# Sync files with appropriate cache settings
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/checkout --metadata-directive 'REPLACE' --cache-control max-age=31536000,public,immutable --exclude "index.html" --exclude "assets/*"
aws s3 sync ./ s3://$S3_ORIGIN_BUCKET/checkout --metadata-directive 'REPLACE' --cache-control no-cache,no-store,must-revalidate --include "index.html" --include "assets/*" --exclude "*"

echo "Deploy completed successfully."
