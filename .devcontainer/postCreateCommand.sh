#!/bin/bash
if [ ! -f ./artisan ]; then
  cp .env.example .env
  sed -i '1 iTRUSTED_PROXIES=*' .env
  composer install && npm install
  php artisan key:generate
  php artisan migrate --force
  php artisan migrate:fresh --seed
fi
