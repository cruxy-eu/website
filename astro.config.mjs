// @ts-check
import { defineConfig } from "astro/config";

import tailwindcss from "@tailwindcss/vite";

import icon from "astro-icon";
import subsetFonts from "./integrations/subset-fonts.js";

import mdx from "@astrojs/mdx";

import sitemap from "@astrojs/sitemap";

const setDefaultMdxLayout = () => {
  return function (_, file) {
    file.data.astro.frontmatter.layout =
      file.data.astro.frontmatter.layout || "@cruxy/layouts/MDXLayout.astro";
  };
};

export default defineConfig({
  site: "https://cruxy.eu",
  output: "static",
  compressHTML: true,
  vite: {
    plugins: [tailwindcss()],
  },
  integrations: [
    icon(),
    subsetFonts(),
    mdx({
      remarkPlugins: [setDefaultMdxLayout],
    }),
    sitemap(),
  ],
});
