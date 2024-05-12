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

Run on separate terminals:
```
php artisan serve
npm run dev
```

Port 5173 must be made public by clicking on the "Ports" tab in Visual Studio. This must be done on initial launch, as well as every subsequent change to config as this will re-launch the port opening and reset it back to private.
