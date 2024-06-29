#!/bin/bash -x
composer create-project laravel/laravel $CONTAINER_WORKSPACE_FOLDER/tmp
cp -r $CONTAINER_WORKSPACE_FOLDER/tmp $CONTAINER_WORKSPACE_FOLDER
rm -rf $CONTAINER_WORKSPACE_FOLDER/tmp
mv -f $CONTAINER_WORKSPACE_FOLDER/devcontainer-postinstall.json $CONTAINER_WORKSPACE_FOLDER/.devcontainer/devcontainer.json
