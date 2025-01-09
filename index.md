---
layout: index_no_header
title: "Sahil Culinary School Portfolio"
---


<div class="intro-section">
  <div class="intro-text">
    <h2>Hey I am Sahil!</h2>
    <p>
      I work in the AI/Data Science fields with interests in the fin-tech space. In most of my spare time outside of this, I am in the kitchen, thinking about the kitchen or learning about the kitchen. Reach out to me at spatel16300@gmail.com!
    </p>
  </div>
  
  <div class="intro-photo">
    <img 
      src="{{ '/assets/images/him.jpg' | relative_url }}" 
      alt="Photo of me in the kitchen"
    >
  </div>
</div>

<!-- The recipe grid or tiles -->
<div class="recipe-grid">
  {% for recipe in site.recipes %}
    <div class="recipe-card">
      <a href="{{ recipe.url | relative_url }}">
        <div class="card-image">
          {% if recipe.image %}
          <img src="{{ recipe.image | relative_url }}" alt="{{ recipe.title }}" />
          {% endif %}
        </div>
        <div class="card-body">
          <h2>{{ recipe.title }}</h2>
        </div>
      </a>
    </div>
  {% endfor %}
</div>