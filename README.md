## Step 1 - vite.config.js

Change the VITE config so that the Codespace's Laravel web server knows where to connect to the VITE instanace.

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

## Step 2 - devcontainer.json

These changes will open the Laravel web server port as well as the VITE port. postCreateCommand will also migrate your database and seed it as required. postAttachCommand will execute the Laravel web server command and execute the VITE server.



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
    "postCreateCommand": "cp .env.example .env && composer install && php artisan key:generate && php artisan migrate --force && php artisan db:seed",
	"postAttachCommand": {
		"vite": "npm run dev",
		"laravel": "php artisan serve",
	  }
}
```

## Step 3 - Change APP_URL



Modify the APP_URL line in your .env.example will ensure that every time the Codespace instance is built, Laravel will have the correct URL.

.env.example
```
APP_URL=https://$CODESPACE_NAME}-8000.app.github.dev
```

## Step 4 - Change VITE Port to be Public

Port 5173 must be made public by clicking on the "Ports" tab in Visual Studio. This needs to be done whenever the container is created or rebuilt.
