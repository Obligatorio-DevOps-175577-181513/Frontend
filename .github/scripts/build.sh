#!/bin/bash
set -e

#### Running build ####
export COMMIT_ID=$(git log --pretty="%h" --no-merges -1)
export COMMIT_DATE="$(git log --date=format:'%Y-%m-%d %H:%M:%S' --pretty="%cd" --no-merges -1)"

#### Print Environment Variables ####
printenv

# Crear los directorios de salida si no existen
mkdir -p dist/apps/catalog
mkdir -p dist/apps/checkout

# Eliminar el contenido de los directorios de salida anteriores
rm -rf ./dist/apps/catalog/*
rm -rf ./dist/apps/checkout/*

# Ejecutar los comandos de construcción de Nx
npm run build catalog
npm run build checkout