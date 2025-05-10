#!/bin/bash

set -e

USER=$(whoami)
DEPLOY_DIR="/home/$USER/deploy"
RELEASES_DIR="/home/$USER/releases"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
NEW_RELEASE_DIR="$RELEASES_DIR/$TIMESTAMP"

echo "Criando nova release em $NEW_RELEASE_DIR"
mkdir -p "$NEW_RELEASE_DIR"
cp -r "$DEPLOY_DIR/"* "$NEW_RELEASE_DIR/"

echo "Atualizando link simbólico para nova release..."
ln -sfn "$NEW_RELEASE_DIR" "/home/$USER/current"

cd "/home/$USER/current"

echo "Executando deploy.sh..."
if ./deploy.sh; then
  echo "Deploy bem-sucedido!"
else
  echo "Erro no deploy. Iniciando rollback..."

  PREVIOUS_RELEASE=$(ls -1t "$RELEASES_DIR" | sed -n 2p)
  if [ -n "$PREVIOUS_RELEASE" ]; then
    ln -sfn "$RELEASES_DIR/$PREVIOUS_RELEASE" "/home/$USER/current"
    echo "Rollback para $PREVIOUS_RELEASE concluído."
  else
    echo "Nenhuma release anterior encontrada. Rollback não possível."
  fi
  exit 1
fi
