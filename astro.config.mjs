// @ts-check
import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";
import icon from "astro-icon";
import subsetFonts from "./integrations/subset-fonts.js";
import defaultMdxLayout from "./integrations/remark/default-mdx-layout.js";
import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";

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
      remarkPlugins: [
        defaultMdxLayout({
          excluded: ["/src/timeline/**"],
          defaultLayout: "@cruxy/layouts/MDXLayout",
        }),
      ],
    }),
    sitemap(),
  ],
});
