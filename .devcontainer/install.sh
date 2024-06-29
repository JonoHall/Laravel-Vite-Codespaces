#!/bin/bash -x
composer create-project laravel/laravel /workspaces/$CODESPACE_NAME/tmp
mv -f /workspaces/$CODESPACE_NAME/tmp/{.,}* /workspaces/$CODESPACE_NAME
rm -rf /workspaces/$CODESPACE_NAME/tmp
mv -f /workspaces/$CODESPACE_NAME/devcontainer-postinstall.json /workspaces/$CODESPACE_NAME/.devcontainer/devcontainer.json
