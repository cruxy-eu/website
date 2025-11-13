import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const timeline = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/timeline" }),
  schema: z.object({
    icon: z.string(),
    entity: z.string(),
    role: z.string().optional(),
    location: z.string().optional(),
    year: z.string(),
    tags: z.array(z.string()).optional(),
    order: z.number(),
  }),
});

export const collections = { timeline };
