// @ts-check
import { defineConfig } from 'astro/config';


import tailwindcss from '@tailwindcss/vite';


export default defineConfig({
  site: 'https://cruxy.eu',
  output: 'static',
  compressHTML: true,
  responsiveImages: true,
  vite: {
    plugins: [tailwindcss()],
  },
});