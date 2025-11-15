import { execSync } from "node:child_process";

export default function subsetFonts() {
  return {
    name: "font-subset",
    hooks: {
      "astro:build:done": async () => {
        execSync("bash scripts/subset-fonts.sh", { stdio: "inherit" });
      },
    },
  };
}
