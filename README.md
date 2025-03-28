This document demonstrates how to run a Laravel install that utilizes Vite asset bundling which is compatible with a Github Codespaces instance.

# Laravel Installation

### Option 1: New installations

If you need to create a project, create a blank GitHub repository and copy the contents of this repository (except "README.md") to it. Boot up a Codespace instance with your new repository, then run through the Laravel install instructions. Something like this:

```
composer global require laravel/installer
laravel new tempapp
mv tempapp/* tempapp/.[^.]* . && rm -r tempapp
```

### Option 2: Existing installation

Follow the steps below to modify your existing installation/configuration.

# Required codespaces compatibility changes

### 1. vite.config.js

Change the Vite config so that when you open the Laravel website your web client will find assets at the correct Vite instanace host/port.

`vite.config.js:`
```
    plugins: [
      ...
    ],
    server: {
        hmr: {
            host: process.env.CODESPACE_NAME ? process.env.CODESPACE_NAME + '-5173.' + process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN : null,
            clientPort: process.env.CODESPACE_NAME ? 443 : null,
            protocol: process.env.CODESPACE_NAME ? 'wss' : null
        },
    }
```

*Technical info: The above changes correct the way Vite generates the 'public/hot' file, before making these changes, Vite would incorrectly generate a host of `http://[::1]:5173`, and unsurprisingly, your browser will be unable to connect to this host. After making these config changes, you will get a host like `https://example-example-123456-5173.app.github.dev:443` which is the Codespace public host address for the Vite server. The ternary operators are to ensure that Laravel to fall back to default settings if the application is deployed in a local dev environment that is not a Codespace.*

### 2. devcontainer.json

Copy the contents of `devcontainer.json` into a file with the path `.devcontainer/devcontainer.json`. 

These commands will open the Laravel web server port as well as the Vite port. postAttachCommand will execute the Laravel web server command and execute the Vite asset server. It will also convert Vite's 5173 port to be public.

*Please note that `artisan migrate --force` will migrate the database. Remove this if you prefer more database manual control*

[devcontainer.json](.devcontainer/devcontainer.json)

### 3. Change Laravel's App URL variable

Modify `APP_URL` in your `.env` (if it exists) and `.env.example` to ensure that every time the Codespace instance is built, Laravel will have the correct URL.

`.env` (if it exists) and `.env.example`
```
APP_URL=https://$CODESPACE_NAME-8000.app.github.dev
```

### 4. Trust all proxies

You must trust all proxies for URLs to generate properly. You will find that your Laravel applications will generate incorrect links such as "Login" pointing to `http://localhost:8000/login`, to fix this, you have to trust the Codespace proxy. This is done with the following:

https://laravel.com/docs/11.x/requests#trusting-all-proxies

`bootstrap/app.php`
```
->withMiddleware(function (Middleware $middleware) {
        $middleware->web(append: [
            \App\Http\Middleware\HandleInertiaRequests::class,
            \Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets::class,
        ]);
        if (env('APP_ENV') == 'local') {
            $middleware->trustProxies(at: '*');
        }
})
```
