---
layout: index_no_header
title: "The recipe collection"
---
<section class="intro-section">
  <div class="intro-text">
    <p class="eyebrow">A personal collection</p>
    <h1>Made in my kitchen.</h1>
    <p>I’m Sahil. I work in AI and data science, but most of my spare time is spent cooking, thinking about cooking, or learning something new in the kitchen. These are the dishes and notes I’ve collected along the way.</p>
  </div>
  <img class="intro-photo" src="{{ '/assets/images/him.jpg' | relative_url }}" alt="Sahil in the kitchen" width="180" height="180">
</section>
<section id="recipes" aria-labelledby="collection-title">
  <div class="section-heading"><h2 id="collection-title">The recipe collection</h2><span>{{ site.recipes.size }} dishes & counting</span></div>
  <div class="recipe-grid">
    {% assign ordered_recipes = site.recipes | sort: 'title' | sort: 'order' %}
    {% for recipe in ordered_recipes %}
    <article class="recipe-card">
      <a href="{{ recipe.url | relative_url }}">
        <div class="card-image">
          {% if recipe.image %}<img src="{{ recipe.image | relative_url }}" alt="{{ recipe.title | escape }}" loading="lazy" width="600" height="450">{% else %}<span class="image-placeholder">From the kitchen</span>{% endif %}
          <span class="card-arrow" aria-hidden="true">↗</span>
        </div>
        <div class="card-body"><h3>{{ recipe.title | escape }}</h3><span class="card-label">View recipe <span aria-hidden="true">→</span></span></div>
      </a>
    </article>
    {% endfor %}
  </div>
</section>
