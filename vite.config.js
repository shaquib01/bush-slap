import { defineConfig } from 'vite';

export default defineConfig({
  base: '/bush-slap/',
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    sourcemap: false,
  },
});
