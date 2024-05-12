## Step 1 - vite.config.js

vite.config.js:
```
    plugins: [
      ...
    ],
    server: {
        hmr: {
            host: process.env.CODESPACE_NAME ? process.env.CODESPACE_NAME + '-5173.app.github.dev' : null,
            clientPort: process.env.CODESPACE_NAME ? 443 : null,
            protocol: process.env.CODESPACE_NAME ? 'wss' : null
        },
    }
```

## Step 2 - vite.config.js

.devcontainer/devcontainer.json

```
{
    "image":"mcr.microsoft.com/devcontainers/universal:2",
    // Use 'forwardPorts' to make a list of ports inside the container available locally.
    "forwardPorts": [8000,5173],
	"portsAttributes": {
		"8000": {
			"label": "Laravel App",
            "onAutoForward": "openPreview"
		},
		"5173": {
			"label": "React App",
		}
	},
    "postCreateCommand": "cp .env.example .env && composer install && php artisan key:generate && yarn install && yarn run development && php artisan migrate && php artisan db:seed",
	"postAttachCommand": {
		"vite": "npm run dev",
		"laravel": "php artisan serve",
	  }
}
```

## Step 3 - Change APP_URL

.env.example

Modify the APP_URL line.

```
APP_URL=https://$CODESPACE_NAME}-8000.app.github.dev
```

## Step 4 - Change Port to be Public

Port 5173 must be made public by clicking on the "Ports" tab in Visual Studio. This needs to be done whenever the container is created or rebuilt.
