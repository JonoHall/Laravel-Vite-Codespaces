#!/bin/bash -x
composer create-project laravel/laravel ${containerWorkspaceFolder}/tmp 
shopt -s dotglob
mv -f ${containerWorkspaceFolder}/tmp/* ${containerWorkspaceFolder}
rm -d ${containerWorkspaceFolder}/tmp
mv -f ${containerWorkspaceFolder}/devcontainer-postinstall.json ${containerWorkspaceFolder}/.devcontainer/devcontainer.json
gh codespace rebuild -c ${devcontainerId}
