import { mergeConfig } from 'vite';
import defineConfig from './vite.config'

export default mergeConfig(defineConfig,{
    server: {
        hmr: {
            host: process.env.CODESPACE_NAME ? process.env.CODESPACE_NAME + '-5173.app.github.dev' : null,
            clientPort: process.env.CODESPACE_NAME ? 443 : null,
            protocol: process.env.CODESPACE_NAME ? 'wss' : null
        }
    }
});
