#!/bin/bash
if -f ./src/install.sh; then
  ./src/install.sh
else
  cp .env.example .env
  sed -i '1 iTRUSTED_PROXIES=*' .env
  composer install && npm install
  php artisan key:generate
  php artisan migrate --force
  php artisan migrate:fresh --seed
fi
