#!/bin/bash
clear
if [ -e package.json ]
then
    npm run dev
else
    echo "npm cannot start, package.json not found. Laravel may not be installed."
fi
