import { minimatch } from "minimatch";

interface Options {
  excluded?: string[];
  defaultLayout: string;
}

export default function defaultMdxLayout(options: Options) {
  // exclude files using glob patterns
  const excluded = options.excluded || [];

  return function (_, file) {
    if (!file) {
      console.warn("No file provided, skipping default layout assignment.");
      return;
    }
    const cwd = file.cwd;
    if (!cwd) {
      console.warn("File has no cwd, skipping default layout assignment.");
      return;
    }
    const filePath = file.history[0].replace(cwd + "/", "");
    console.log("Processing file:", filePath);

    const shouldExclude = excluded.some((pattern) =>
      minimatch(filePath, pattern),
    );
    // Skip if file matches exclusion pattern
    if (shouldExclude) {
      return;
    }

    file.data.astro.frontmatter.layout =
      file.data.astro.frontmatter.layout || options.defaultLayout;
  };
}
