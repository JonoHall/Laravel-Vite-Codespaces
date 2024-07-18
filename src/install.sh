#!/bin/bash

#install Laravel to a temporary folder, as Laravel won't install into a non-empty directory
#composer create-project laravel/laravel=11.* ./tmp --prefer-dist --ignore-platform-req=php
composer create-project laravel/laravel ./tmp

#move all files including . files, then delete the now empty folder
shopt -s dotglob
rm ./README.md
mv -f ./tmp/* ./
rm -rf ./tmp

#move the Codespace specific config files
mv ./src/vite-codespaces.config.js ./
mv ./src/config/trustedproxy.php ./config
mkdir ./.vscode && mv ./src/.vscode/tasks.json ./.vscode/tasks.json
npm pkg set scripts.dev="vite --config vite-codespaces.config.js"

#finish setup
cp .env.example .env
sed -i '1 iTRUSTED_PROXIES=*' .env
composer install && npm install
php artisan key:generate
php artisan migrate --force
php artisan migrate:fresh --seed

#cleanup files
rm -r ./src

#farewell and good luck!
clear
echo Install complete! Your Codespace will now be stopped, please refresh your screen and restart the Codespace.
gh codespace stop -c $CODESPACE_NAME

