vite.config.js:
```
    plugins: [
      ...
    ],
    server: {
        hmr: {
            host: process.env.CODESPACE_NAME + '-5173.app.github.dev',
            clientPort: 443,
            protocol: 'wss'
        },
    }
```

Run:
php artisan serve
npm run dev

Port 5173 must be made public
