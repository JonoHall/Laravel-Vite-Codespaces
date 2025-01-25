#!/bin/bash
clear
if [ -e artisan ]
then
    php artisan serve
else
    echo "Laravel Artisan not found. Laravel may not be installed."
fi
