import H1 from "./H1.astro";
import H2 from "./H2.astro";
import H3 from "./H3.astro";
import Paragraph from "./Paragraph.astro";
import List from "./List.astro";
import ListItem from "./ListItem.astro";

export const components = {
  h1: H1,
  h2: H2,
  h3: H3,
  p: Paragraph,
  ul: List,
  ol: List,
  li: ListItem,
};
