#!/bin/bash
set -e

#### Running build ####
export COMMIT_ID=$(git log --pretty="%h" --no-merges -1)
export COMMIT_DATE="$(git log --date=format:'%Y-%m-%d %H:%M:%S' --pretty="%cd" --no-merges -1)"

#### Print Environment Variables ####
printenv

# Eliminar el directorio de salida anterior
rm -rf ./dist/*

# Ejecutar el comando de construcción de Nx
npm run build