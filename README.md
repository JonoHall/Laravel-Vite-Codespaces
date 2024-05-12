How to run a vanilla install of Laravel and Vite asset bundling on a Github Codespaces instance.

## Step 1 - vite.config.js

Change the Vite config so that when you open the Laravel website with your web client, your browser knows where to connect to the Vite instanace.

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

Technical info: The above changes correct the way Vite generates the 'public/hot' file, before making these changes, Vite would incorrectly generate a host of `http://[::1]:5173`, after making these config changes, you will get a host like `https://example-example-123456-5173.app.github.dev:443` which is the public host address for the Vite server.

## Step 2 - devcontainer.json

The following changes will open the Laravel web server port as well as the Vite port. postAttachCommand will execute the Laravel web server command and execute the Vite asset server.

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
			"label": "React App"
		}
	},
    "postCreateCommand": "cp .env.example .env && composer install && php artisan key:generate",
	"postAttachCommand": {
		"vite": "npm run dev",
		"laravel": "php artisan serve"
	  }
}
```

## Step 2b - Migrate/Seed Databse Automatically

Modify the postCreateCommand line to automatically migrate and seed the database.

```
 "postCreateCommand": "cp .env.example .env && composer install && php artisan key:generate",
```

## Step 3 - Change APP_URL

Modify the APP_URL line in your .env.example will ensure that every time the Codespace instance is built, Laravel will have the correct URL.

.env.example
```
APP_URL=https://$CODESPACE_NAME}-8000.app.github.dev
```

## Step 4 - Change VITE Port to be Public

Port 5173 must be made public by clicking on the "Ports" tab in Visual Studio. This needs to be done whenever the container is created or rebuilt.
