#!/bin/bash
composer create-project laravel/laravel $CODESPACE_VSCODE_FOLDER/tmp
shopt -s dotglob
mv -f $CODESPACE_VSCODE_FOLDER/tmp/* $CODESPACE_VSCODE_FOLDER
rm -rf $CODESPACE_VSCODE_FOLDER/tmp
mv -f $CODESPACE_VSCODE_FOLDER/src/devcontainer-postinstall.json $CODESPACE_VSCODE_FOLDER/.devcontainer/devcontainer.json
rm $CODESPACE_VSCODE_FOLDER/README.md
cp ./src/vite.config.js ./vite.config.js
rm -r ./src
sed -i '/->withMiddleware(function (Middleware $middleware) {/a \\tif (env("APP_ENV") == "local") {\n\t\t$middleware->trustProxies(at: "*");\n\t}' ./bootstrap/app.php
clear
echo "Your Codespace has been configured and now needs rebuilding. This may take a moment."
gh codespace rebuild -c $CODESPACE_NAME
