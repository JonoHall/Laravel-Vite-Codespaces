#!/bin/bash

#install Laravel to a temporary folder, as Laravel won't install into a non-empty directory
composer create-project laravel/laravel=11.* ./tmp --prefer-dist

#move all files including . files, then delete the now empty folder
shopt -s dotglob
rm ./README.md
mv -f ./tmp/* ./
rm -rf ./tmp


#move the Codespace specific config files
mv -f ./src/devcontainer-postinstall.json ./.devcontainer/devcontainer.json
mv ./src/vite-codespaces.config.js ./
mv ./src/trustedproxy.php ./config
sed -i '1s/^/TRUSTED_PROXIES=*\n /' .env
npm pkg set scripts.dev="vite --config vite-codespaces.config.js"

#cleanup files
rm -r ./src
rm ./README.md

#farewell and good luck!
clear
echo "Your Codespace has been configured and is rebuilding. Please refresh your browser to reconnect."
gh codespace rebuild -c $CODESPACE_NAME
