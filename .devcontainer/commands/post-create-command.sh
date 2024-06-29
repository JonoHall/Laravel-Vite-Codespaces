#!/bin/bash -x
composer create-project laravel/laravel ~/tmp
cp -r ~/tmp /workspaces/$RepositoryName
rm -rf ~/tmp
mv -f /workspaces/$RepositoryName/devcontainer-postinstall.json /workspaces/$RepositoryName/.devcontainer/devcontainer.json
