---
layout: single
title: "Welcome to My Recipes"
---

## Explore My Favorite Dishes

{% for recipe in site.recipes %}
  <div class="recipe-card">
    <a href="{{ recipe.url | relative_url }}">
      {% if recipe.image %}
      <img src="{{ recipe.image | relative_url }}" alt="{{ recipe.title }}">
      {% endif %}
      <h2>{{ recipe.title }}</h2>
    </a>
  </div>
{% endfor %}
