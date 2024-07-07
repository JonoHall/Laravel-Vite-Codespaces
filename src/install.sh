#!/bin/bash
composer create-project laravel/laravel $CODESPACE_VSCODE_FOLDER/tmp
shopt -s dotglob
mv -f $CODESPACE_VSCODE_FOLDER/tmp/* $CODESPACE_VSCODE_FOLDER
rm -rf $CODESPACE_VSCODE_FOLDER/tmp
mv -f $CODESPACE_VSCODE_FOLDER/src/devcontainer-postinstall.json $CODESPACE_VSCODE_FOLDER/.devcontainer/devcontainer.json
rm $CODESPACE_VSCODE_FOLDER/README.md
cp ./src/vite.config.js ./vite.config.js
sed -i "/withMiddleware/r ./src/trusted-proxy.php" ./bootstrap/app.php
rm -r ./src
clear
echo "Your Codespace has been configured and is rebuilding. Please refresh your browser to reconnect."
gh codespace rebuild -c $CODESPACE_NAME
