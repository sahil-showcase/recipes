require 'minitest/autorun'
require 'jekyll'
require 'ostruct'
require_relative '../_plugins/recipe_redirects'

class RecipeRedirectsTest < Minitest::Test
  Recipe = Struct.new(:basename_without_ext, :url, :data)
  def build_site(history: {}, baseurl: '', recipes: nil)
    recipes ||= [Recipe.new('duck', '/duck/', {})]
    OpenStruct.new(collections: {'recipes' => OpenStruct.new(docs: recipes)}, data: {'legacy_recipe_slugs' => history}, pages: [], docs_to_write: recipes, baseurl: baseurl)
  end
  def generate(site)
    RecipeRoutes::Generator.new.generate(site)
    site.collections['recipes'].docs.first.data['redirect_from']
  end
  def test_automatic_clean_alias_and_historical_numbered_names
    site = build_site(history: {'duck' => ['01-duck', '004-Duck']})
    aliases = generate(site)
    assert_includes aliases, '/recipes/recipes/duck/'
    assert_includes aliases, '/recipes/01-duck/'
    assert_includes aliases, '/recipes/recipes/01-duck/'
    assert_includes aliases, '/recipes/004-Duck/'
    assert_includes aliases, '/recipes/004-duck/'
    refute_includes aliases, '/duck/'
    assert_equal aliases.uniq, aliases
  end
  def test_project_mount_supports_both_public_prefixes
    aliases = generate(build_site(history: {'duck' => ['01-duck']}, baseurl: '/recipes'))
    # The public URLs are /recipes + each relative alias.
    assert_includes aliases, '/recipes/duck/'
    assert_includes aliases, '/01-duck/'
    assert_includes aliases, '/recipes/01-duck/'
    refute_includes aliases, '/duck/'
  end
  def test_underscores_and_existing_exceptional_aliases
    recipe = Recipe.new('duck', '/duck/', {'redirect_from'=>['/old-favorite/']})
    aliases = generate(build_site(history: {'duck'=>['01_duck_breast']}, recipes:[recipe]))
    assert_includes aliases, '/recipes/01_duck_breast/'
    assert_includes aliases, '/recipes/01-duck-breast/'
    assert_includes aliases, '/old-favorite/'
  end
  def test_new_recipes_need_no_per_file_redirects
    aliases = generate(build_site)
    assert_equal ['/recipes/duck/', '/recipes/recipes/duck/'], aliases
  end
  def test_missing_recipe_target_fails_build
    assert_raises(Jekyll::Errors::FatalException) { generate(build_site(history: {'missing'=>['01-missing']})) }
  end
  def test_collision_cannot_overwrite_a_recipe
    recipes = [Recipe.new('duck','/duck/',{}), Recipe.new('01-duck','/01-duck/',{})]
    assert_raises(Jekyll::Errors::FatalException) { generate(build_site(history: {'duck'=>['01-duck']}, recipes:recipes, baseurl:'/recipes')) }
  end
  def test_two_recipes_cannot_claim_same_alias
    recipes = [Recipe.new('duck','/duck/',{}), Recipe.new('chicken','/chicken/',{})]
    assert_raises(Jekyll::Errors::FatalException) { generate(build_site(history: {'duck'=>['01-bird'],'chicken'=>['01-bird']}, recipes:recipes)) }
  end
end
