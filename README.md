How to run a vanilla install of Laravel and Vite asset bundling on a Github Codespaces instance.

## Step 1 - vite.config.js

Change the Vite config so that when you open the Laravel website with your web client, your browser knows where to connect to the Vite instanace.

`vite.config.js:`
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

*Technical info: The above changes correct the way Vite generates the 'public/hot' file, before making these changes, Vite would incorrectly generate a host of `http://[::1]:5173`, and unsurprisingly, your browser will be unable to connect to this host. After making these config changes, you will get a host like `https://example-example-123456-5173.app.github.dev:443` which is the Codespace public host address for the Vite server. The ternary operators are to ensure that Laravel to fall back to default settings if the application is deployed in a local dev environment that is not a Codespace.*

## Step 2 - devcontainer.json

The following changes will open the Laravel web server port as well as the Vite port. postAttachCommand will execute the Laravel web server command and execute the Vite asset server. It will also convert Vite's 5173 port to be public.

`.devcontainer/devcontainer.json`
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
    "postCreateCommand": "cp .env.example .env && composer install && npm install && php artisan key:generate && gh codespace ports visibility 5173:public -c $CODESPACE_NAME",
	"postAttachCommand": {
		"vite": "npm run dev",
		"laravel": "php artisan serve"
	  }
}
```

### Step 2b - OPTIONAL Migrate/Seed Databse Automatically

Modify the postCreateCommand line to automatically migrate and seed the database. *USE AT OWN RISK, DATABASE WILL BE OVERWRITTEN EVERY CODESPACE REBUILD*.
`.devcontainer/devcontainer.json`
```
 "postCreateCommand": "cp .env.example .env && composer install && npm install && php artisan key:generate && gh codespace ports visibility 5173:public -c $CODESPACE_NAME && php artisan migrate --force",
```

## Step 3 - Change Laravel's App URL variable

Add a CODESPACES_APP_URL line to your .env.example will ensure that every time the Codespace instance is built, Laravel will have the correct URL.

`.env.example`
```
APP_URL=http://localhost
CODESPACES_APP_URL=https://$CODESPACE_NAME}-8000.app.github.dev
```

Modify the App Config `url` line to use the new environment variable.

`config/app.php`
```
'url' => (env('CODESPACES_APP_URL', env('APP_URL', 'http://localhost'))),
```

*Technical info: This could be done using just APP_URL, but I wanted Laravel to fall back to default settings if the application is deployed in a local dev environment if not deployed in a Codespace.*

## Step 4 - Trust all proxies

You must trust all proxies for URLs to generate properly. You will find that your Laravel applications will generate incorrect links such as "Login" pointing to `http://localhost:8000/login`, to fix this, you have to trust the Codespace proxy. This is done with the following:

https://laravel.com/docs/11.x/requests#trusting-all-proxies

`bootstrap/app.php`
```
->withMiddleware(function (Middleware $middleware) {
        if (env('APP_ENV') == 'local') {
            $middleware->trustProxies(at: '*');
        }
})
```
