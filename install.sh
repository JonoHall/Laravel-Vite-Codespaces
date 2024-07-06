#!/bin/bash
composer create-project laravel/laravel $CODESPACE_VSCODE_FOLDER/tmp
shopt -s dotglob
mv -f $CODESPACE_VSCODE_FOLDER/tmp/* $CODESPACE_VSCODE_FOLDER
rm -rf $CODESPACE_VSCODE_FOLDER/tmp
mv -f $CODESPACE_VSCODE_FOLDER/devcontainer-postinstall.json $CODESPACE_VSCODE_FOLDER/.devcontainer/devcontainer.json
rm $CODESPACE_VSCODE_FOLDER/install.sh
rm $CODESPACE_VSCODE_FOLDER/README.md
cp ./src/vite.config.js ./vite.config.js
sed -i '/->withMiddleware(function (Middleware $middleware) {/a \\t\t$middleware->trustProxies(at: "*");' ./bootstrap/app.php
clear
read -n 1 -s -r -p "Your Codespace has been configured and now needs rebuilding. This may take a moment. Press any key to continue"
gh codespace rebuild -c $CODESPACE_NAME
