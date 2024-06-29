#!/bin/bash -x
composer create-project laravel/laravel /workspaces/$RepositoryName/tmp
mv -f /workspaces/$RepositoryName/tmp/{.,}* /workspaces/$RepositoryName
rm -rf /workspaces/$RepositoryName/tmp
mv -f /workspaces/$RepositoryName/devcontainer-postinstall.json /workspaces/$RepositoryName/.devcontainer/devcontainer.json
