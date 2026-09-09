# Sahil’s Kitchen

A Jekyll recipe website with a short introduction and photo above a grid of dishes. Recipe pages show a centered main photo, with ingredients and readable steps below it.

## Add a recipe in three steps

1. **Upload a photo** to `assets/images/`. Use a simple name, for example `lemon-tart.jpg`.
2. **Copy `_templates/NEW-RECIPE-TEMPLATE.md`** to `_recipes/lemon-tart.md`. Replace the title, description, image path, ingredients, steps, and references. The template includes each supported type. Keep the two `---` lines. The new template puts structured steps above the second line; optional extra Markdown notes go below it.
3. **Set `order`** to a unique number for the tile’s position. Save and publish through your existing GitHub Pages setup. The tile and recipe page are generated automatically.

You only need one Markdown file and one photo per recipe. No edits to the homepage, layouts, or code are needed. Do not edit generated `_site/` files.

## Choose where a tile appears

The `order` number at the top of each recipe controls its tile position. Existing recipes use consecutive numbers **1–100**, preserving the current sequence. Tiles run left to right, then down; the number of columns changes with screen size.

```yaml
order: 1
```

Use `101` for the next new recipe, `102` for the one after that, and so on. To move a recipe to position 5, set its order to `5` and shift the affected recipes so all values remain unique and consecutive. For a simple swap, exchange the two recipes’ order values.

Use numbers without quotes. Titles are only used to break a tie if two recipes accidentally share an order value. Recipes without an order fall back to the end, so always fill in this field.

Recipe and photo filenames have **no numeric prefixes**. For example, `_recipes/baklava-cheesecake.md` references `/assets/images/baklava-cheesecake.jpg`, and its page is `/recipes/baklava-cheesecake/` (after any configured site base path). The filename determines the URL; `order` only controls tile placement. Changing the order never changes the recipe URL.

## What to fill in

| Field / section | What goes here |
| --- | --- |
| `layout` | Keep `recipe`. |
| `order` | Unique number controlling homepage placement. |
| `title` | The dish’s name, shown on its tile and page. |
| `description` | Short introduction below the page title; optional. |
| `image` | Exact photo path, e.g. `/assets/images/lemon-tart.jpg`. |
| `ingredients` | One quoted ingredient and quantity per `-` line. |
| `references` | Named image, video, website, or note references; see the examples below. |
| `steps` | Ordered step blocks with `title`, `text`, optional `before` / `after`, and `citations`. |
| `method_intro` / `method_outro` | Optional descriptive blurbs above and below the full method. |
| `## Notes` | Optional tips, substitutions, or make-ahead instructions. |

Citations and references appear in a dedicated section below the written method. Supported videos embed there with a source link that remains available without JavaScript. Existing URLs in older recipe notes still work. Original recipe content is preserved; entries with placeholder ingredients or missing methods still need your own content.

Keep filenames unique and ingredient text quoted, particularly when it contains a colon. Copy the template rather than starting from a blank file.

## Local preview and publishing

Use a modern Ruby installation compatible with Bundler 2.6.2, then:

```sh
bundle install
bundle exec jekyll serve
```

Open the local address printed by Jekyll. To check a production build, run `bundle exec jekyll build`. Commit and push the source changes using your existing GitHub Pages publishing setup.

For a project site hosted under `/recipes`, configure `baseurl: "/recipes"` in `_config.yml` (or pass `--baseurl /recipes`). For a domain-root site, leave it empty. Local navigation, images, scripts, and stylesheets use Jekyll’s `relative_url` filter.

## Older recipe links

Existing `/recipes/recipes/dish-name/` links redirect to `/recipes/dish-name/`. Each existing recipe declares its old path in `redirect_from`, and `jekyll-redirect-from` (already included in the GitHub Pages dependencies) generates a small redirect page during the build. These are browser redirects, not server-side HTTP 301 responses. The current homepage still links to the shorter canonical routes.

When copying a recipe, remove its `redirect_from` block unless you need an old URL, or replace the alias with the correct filename. Never copy another recipe’s alias unchanged. Restart `jekyll serve` after configuration changes so the plugin is loaded. Paths here assume an empty `baseurl`, as in the current configuration.

## Structured recipe example

`_recipes/tandoori-chicken.md` (Silkie Chicken Tandoori) is a complete working example. `_templates/NEW-RECIPE-TEMPLATE.md` is the blank copy-and-fill template. Existing Markdown-only recipes continue to render without conversion.

- **Ingredients:** write a YAML list of strings, or `text` / `group` blocks for optional grouping. They display as 1, 2, 3 in exactly that order. Move list items to reorder; do not put numbers in the text.
- **Steps:** each `- title:` block is the next numbered step. `text: |` supports paragraphs and Markdown. `before` and `after` are optional descriptors inside that step; `method_intro` and `method_outro` describe the full method.
- **Citations:** give each reference a unique stable ID such as `finished-dish`, then add `citations: [finished-dish]` to a step. The step gets a numbered link to the reference section, and the reference links back to the step. Reordering references updates their displayed citation numbers automatically.
- **Inline citations:** write `[cite:finished-dish]` within step `text`, `before`, or `after` to get an automatic numbered reference link, with a link back to the step. No `citations` list is needed. Add the ID to `citations` as well only if you also want an end-of-step link/image preview/note. Markers also work in `method_intro` and `method_outro`. Standard Markdown `[see photo](#reference-finished-dish)` links still work.
- **Image:** `type: image`, a `url` such as `/assets/images/photo.jpg` (or an HTTPS image URL), `alt`, and optional `caption`. A cited image appears as a linked preview beneath its step and in the reference section. Click the full reference image to open the original.
- **Video:** `type: video`, `url`, `label`, and optional `caption`. YouTube watch/share/shorts URLs and direct `.mp4`, `.webm`, or `.ogg` files embed. Upload local videos under `assets/videos/`. Other video hosts appear as clickable source links.
- **Website:** `type: website`, an HTTP(S) `url`, `label`, and optional `caption`.
- **Text / legend:** `type: note`, `label`, and `text`. A cited note displays as subtext beneath its step and in the dedicated reference section. No URL is needed.

All reference types share `id` and `label`. Use lowercase letters, numbers, and hyphens in IDs, starting with a letter. Delete unused fields and blocks; use `citations: []` or omit it for steps without citations. New recipes do not need legacy `redirect_from` aliases.

Before publishing, check filenames, ordering, and citations:

```sh
bundle exec ruby scripts/check-recipes.rb
```

This catches duplicate IDs, missing citation targets, invalid reference types, missing local photos/videos, and incorrect tile ordering. It does not check whether external URLs are still available. Then run `bundle exec jekyll build` or restart your preview server after configuration changes.

## Optional groups for ingredients and steps

Keep one ordered list; add a `group` label only to items you want grouped. Grouping does not sort, move, or restart numbering. Consecutive items with the same group share a heading; the same label used again later starts a new section in that position. Each item is independent: omitting `group`, or setting it to `""`, returns to ungrouped content.

```yaml
ingredients:
  - "1 whole chicken"  # Ungrouped; ingredient 1.
  - text: "200 g yogurt"
    group: "Marinade"  # Ingredient 2.
  - text: "1 tsp cumin"
    group: "Marinade"  # Ingredient 3, under the same heading.
  - "Lime, to serve"   # Ungrouped again; ingredient 4.

steps:
  - title: "Prepare"
    text: "Prepare the ingredients."  # Ungrouped step 1.
  - title: "Mix"
    group: "Marinade"
    text: "Mix the marinade. [cite:video-example]"
  - title: "Coat"
    group: "Marinade"
    text: "Coat the chicken."
  - title: "Finish"
    text: "Finish and serve."  # Ungrouped again; step 4.
```

Define `video-example` in `references` when using that inline citation. The checker validates group values and catches missing inline reference IDs. Both the silkie chicken example and the copyable template demonstrate optional groups and inline citations.
