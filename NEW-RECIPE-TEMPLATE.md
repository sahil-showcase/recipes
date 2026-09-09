---
# ======================================================================
# NEW RECIPE — COPY THIS FILE, THEN FILL IT IN
# ======================================================================
# 1. Copy this file into _recipes/ and name it after your dish.
#    Example: _recipes/lemon-tart.md -> website URL /recipes/lemon-tart/
# 2. Put your main photo in assets/images/.
#    Example: assets/images/lemon-tart.jpg
# 3. Replace every REPLACE instruction and example photo / link below.
# 4. Save, run the checker, then preview your recipe.
#
# Working example: _recipes/tandoori-chicken.md (Silkie Chicken Tandoori).
# This template itself stays outside _recipes/ so it is not a recipe tile.
#
# EDITING RULES
# - Keep indentation: use spaces, not tabs.
# - Keep text inside quotes, especially if it contains a colon (:).
# - For long text, use | and indent each line as the examples show.
# - Lines starting with # are instructions; visitors never see them.
# - Keep the opening and closing --- lines.

# ======================================================================
# 1. RECIPE DETAILS — REQUIRED
# ======================================================================
layout: recipe  # Leave this unchanged.

# Your tile position: 1 is first, 2 is second, and so on.
# Use the next unused number. There are currently 100 recipes, so next is 101.
# To move a recipe, adjust other order values to keep 1 through N unique.
order: 101

title: "REPLACE: Name of your dish"
description: "REPLACE: One or two sentences introducing this dish."

# Match your uploaded filename exactly. Do not include the site domain.
image: /assets/images/your-recipe-photo.jpg

# ======================================================================
# 2. INGREDIENTS — REQUIRED
# ======================================================================
# Add one ingredient per line. Copy a line to add another ingredient.
# The website adds 1, 2, 3 automatically, in exactly this order.
# Move entire items to reorder. Do not type numbers into the ingredient text.
# GROUPS ARE OPTIONAL: use a text/group block for a grouped ingredient.
# Plain text items are ungrouped. Group labels do not carry over to later items.
# Consecutive items with the same group share one heading.
# An omitted group (or group: "") means ungrouped; numbers keep counting.
ingredients:
  - "REPLACE: Quantity and first ingredient, e.g. 200 g flour"
  - text: "REPLACE: Quantity and second ingredient, e.g. 2 eggs"
    group: "REPLACE: Group name, e.g. Batter"
  - text: "REPLACE: Quantity and third ingredient"
    group: "REPLACE: Group name, e.g. Batter"
  - "REPLACE: Another ungrouped ingredient, e.g. garnish"

# ======================================================================
# 3. METHOD INTRODUCTION AND FINISHING BLURB — OPTIONAL
# ======================================================================
# These appear above and below the WHOLE numbered step list.
# Delete either field if you do not want a blurb there.
method_intro: "REPLACE: Preparation overview or anything to know before starting."
method_outro: "REPLACE: Serving instructions, finishing notes, or storage advice."

# ======================================================================
# 4. COOKING STEPS — REQUIRED
# ======================================================================
# Each '- title' block becomes the next numbered step automatically.
# Copy a whole block to add a step; move a whole block to change its order.
# Only text is required within a step; the other fields (including group) are optional.
# A blank line inside text: | starts a new paragraph in the SAME step.
# Optional group: "Sauce" puts a step under that heading.
# Repeat the same group on consecutive steps to share one heading.
# Omit group (or use group: "") for an ungrouped step. Numbers keep counting.
# INLINE CITATIONS: type [cite:website-example] anywhere in text/before/after
# or method_intro/method_outro. It becomes a clickable numbered reference.
# No citations list is needed for inline-only references. Keep citations
# when you ALSO want an end-of-step link, image preview, or note below it.
steps:
  - title: "REPLACE: Short step heading, e.g. Prepare the ingredients"
    before: "REPLACE: Optional descriptor above this step's instructions."
    text: |
      REPLACE: Write the instructions for this step here.
      **Bold text** can highlight a useful detail.

      REPLACE: Add another paragraph here if needed, or delete this paragraph.
    after: "REPLACE: Optional descriptor below this step's instructions."
    # These IDs connect this step to the image and text note in section 5.
    # Keep the example IDs or rename them consistently in both places.
    citations: [photo-example, note-example]

  - title: "REPLACE: Short step heading, e.g. Cook"
    group: "REPLACE: Step group name, e.g. Cooking"
    text: |
      REPLACE: Give the cooking instructions, including time, temperature,
      and how to tell when the food is ready. [cite:website-example]
      Add a video citation exactly where it helps the reader. [cite:video-example]
    # The two references above are inline, so no end-of-step list is needed.

  - title: "REPLACE: Short step heading, e.g. Finish and serve"
    group: "REPLACE: Step group name, e.g. Cooking"
    text: |
      REPLACE: Describe how to finish and serve the dish.
    citations: []  # No references for this step. You can also delete this line.

# ======================================================================
# 5. CITATIONS AND REFERENCES — OPTIONAL; FOUR COPYABLE EXAMPLES
# ======================================================================
# All references appear in one section directly below the method.
# Clicking a step citation jumps there; a back link returns to the step.
# The website numbers references automatically in the order below.
#
# To ADD a reference: copy its entire block and give it a new unique id.
# IDs use lowercase letters, numbers, and hyphens, starting with a letter.
# Add the new id to the relevant step's citations: [your-new-id].
#
# To REMOVE a reference: delete its block AND its id from step citations.
# To use NO references: replace this whole section with references: []
# and use citations: [] (or remove citations) in every step.
references:
  # A. IMAGE — clickable preview under the step, with a caption beneath it.
  # Upload another photo to assets/images/, or reuse your main photo.
  - id: photo-example
    type: image
    label: "REPLACE: Short photo label, e.g. Finished dish"
    url: /assets/images/your-recipe-photo.jpg
    alt: "REPLACE: Describe what is visible in the photo."
    caption: "REPLACE: Caption or legend explaining what to look for."

  # B. VIDEO — embedded player plus a clickable source link.
  # Paste a YouTube watch/share/shorts URL, a direct .mp4/.webm/.ogg URL,
  # or a local path such as /assets/videos/your-video.mp4.
  # Other video hosts still display a clickable link.
  - id: video-example
    type: video
    label: "REPLACE: Short video label, e.g. Shaping demonstration"
    url: "https://www.youtube.com/watch?v=REPLACE_ME"
    caption: "REPLACE: What the video demonstrates or which part to watch."

  # C. WEBSITE — a labeled link with an optional explanation below the method.
  - id: website-example
    type: website
    label: "REPLACE: Website or article name"
    url: "https://example.com/replace-with-your-source"
    caption: "REPLACE: Explain why this source is useful."

  # D. TEXT NOTE / LEGEND — subtext below a step; no link or photo needed.
  # It is still clickable as a citation and appears in the reference section.
  - id: note-example
    type: note
    label: "REPLACE: Short note label, e.g. Texture tip"
    text: |
      REPLACE: Write a helpful explanation, observation, or legend here.
      Markdown formatting such as **bold text** is supported.
---

<!--
OPTIONAL EXTRA NOTES
Write extra Markdown below this comment if you need notes beyond the fields above.
Leave this area empty if you do not need it.

BEFORE PUBLISHING
- Replace every REPLACE instruction and example URL / photo path.
- Remove optional fields and reference blocks you are not using.
- Check that citation IDs match the references you kept.
- From the repository folder, run:
    bundle exec ruby scripts/check-recipes.rb
- Preview with:
    bundle exec jekyll serve --livereload --baseurl ""
-->
