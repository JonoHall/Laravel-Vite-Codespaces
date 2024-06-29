#!/bin/bash -x
composer create-project laravel/laravel ~/tmp
cp -r ~/tmp $CONTAINER_WORKSPACE_FOLDER
rm -rf ~/tmp
mv -f $CONTAINER_WORKSPACE_FOLDER/devcontainer-postinstall.json $CONTAINER_WORKSPACE_FOLDER/.devcontainer/devcontainer.json
