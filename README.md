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

*Please note that `artisan migrate --force` will migrate the database. Remove this if you prefer more database manual control*

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
    "postCreateCommand": "cp .env.example .env && composer install && npm install && php artisan key:generate && gh codespace ports visibility 5173:public -c $CODESPACE_NAME && php artisan migrate --force",
	"postAttachCommand": {
		"vite": "npm run dev",
		"laravel": "php artisan serve"
	  }
}
```

## Step 3 - Change Laravel's App URL variable

Modify `APP_URL` in your `.env.example` to ensure that every time the Codespace instance is built, Laravel will have the correct URL.

`.env.example`
```
APP_URL=https://$CODESPACE_NAME}-8000.app.github.dev
```

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
