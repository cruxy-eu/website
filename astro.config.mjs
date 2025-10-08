// @ts-check
import { defineConfig } from "astro/config";

import tailwindcss from "@tailwindcss/vite";

import icon from "astro-icon";
import subsetFonts from "./integrations/subset-fonts.js";

export default defineConfig({
  site: "https://cruxy.eu",
  output: "static",
  compressHTML: true,
  vite: {
    plugins: [tailwindcss()],
  },
  integrations: [icon(), subsetFonts()],
});
