#!/bin/bash

#install Laravel to a temporary folder, as Laravel won't install into a non-empty directory
composer create-project laravel/laravel=11.* $CODESPACE_VSCODE_FOLDER/tmp --prefer-dist

#move all files including . files, then delete the now empty folder
shopt -s dotglob
rm $CODESPACE_VSCODE_FOLDER/README.md
mv -f $CODESPACE_VSCODE_FOLDER/tmp/* $CODESPACE_VSCODE_FOLDER
rm -rf $CODESPACE_VSCODE_FOLDER/tmp


#move the Codespace specific config files
mv -f $CODESPACE_VSCODE_FOLDER/src/devcontainer-postinstall.json $CODESPACE_VSCODE_FOLDER/.devcontainer/devcontainer.json
mv ./src/vite-codespaces.config.js ./
npm pkg set scripts.dev="vite --config vite-codespaces.config.js"

#inject Trusted Proxy config into bootstrap config
sed -i "/withMiddleware/r ./src/trusted-proxy.php" ./bootstrap/app.php

#cleanup files
rm -r ./src
rm $CODESPACE_VSCODE_FOLDER/README.md

#farewell and good luck!
clear
echo "Your Codespace has been configured and is rebuilding. Please refresh your browser to reconnect."
gh codespace rebuild -c $CODESPACE_NAME
