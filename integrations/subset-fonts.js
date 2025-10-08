export default function subsetFonts() {
  return {
    name: "font-subset",
    hooks: {
      "astro:build:done": async () => {
        const { execSync } = await import("child_process");
        console.log("🔤 Subsetting fonts...");
        execSync("bash scripts/subset-fonts.sh", { stdio: "inherit" });
      },
    },
  };
}
