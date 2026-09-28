import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { readFileSync } from 'node:fs'

const pkg = JSON.parse(readFileSync('./package.json', 'utf-8'))

// Versi diambil dari env APP_VERSION (mis. dari pipeline), fallback ke package.json
export default defineConfig({
  plugins: [vue()],
  define: {
    __APP_VERSION__: JSON.stringify(process.env.APP_VERSION || pkg.version),
    __APP_NAME__: JSON.stringify(process.env.APP_NAME || 'Sample Application'),
  },
})
