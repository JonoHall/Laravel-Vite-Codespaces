#!/bin/bash -x
composer create-project laravel/laravel $CODESPACE_VSCODE_FOLDER/tmp
mv -f $CODESPACE_VSCODE_FOLDER/tmp/{.,}* $CODESPACE_VSCODE_FOLDER
rm -rf $CODESPACE_VSCODE_FOLDER/tmp
mv -f $CODESPACE_VSCODE_FOLDER/devcontainer-postinstall.json $CODESPACE_VSCODE_FOLDER/.devcontainer/devcontainer.json
