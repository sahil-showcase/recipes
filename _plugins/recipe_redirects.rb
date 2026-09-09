require "uri"
require "fastimage"

# Generate aliases before jekyll-redirect-from creates its static redirect pages.
# Historical filenames live in _data/legacy_recipe_slugs.yml, not recipe files.
module RecipeRoutes
  class Generator < Jekyll::Generator
    priority :highest

    def generate(site)
      collection = site.collections['recipes']
      return unless collection
      history = site.data.fetch('legacy_recipe_slugs', {})
      fail_build('legacy_recipe_slugs must be a mapping') unless history.is_a?(Hash)
      recipes = collection.docs
      names = recipes.map(&:basename_without_ext)
      unknown = history.keys - names
      fail_build("Historical routes reference missing recipes: #{unknown.join(', ')}") unless unknown.empty?
      occupied = (site.pages + site.docs_to_write).map(&:url)
      claims = {}
      baseurl = site.baseurl.to_s.sub(%r{/$}, '')

      recipes.each do |recipe|
        old_names = history.fetch(recipe.basename_without_ext, [])
        fail_build("Historical names for #{recipe.basename_without_ext} must be a list") unless old_names.is_a?(Array)
        current_name = recipe.url.split('/').last
        names = ([current_name] + old_names).flat_map do |name|
          fail_build("Invalid historical name: #{name.inspect}") unless name.is_a?(String) && !name.empty? && !name.match?(%r{[/\\?#]}) && !%w[. ..].include?(name)
          # :title preserves case and underscores. Lowercase and normalized
          # variants also support links people copied from earlier layouts.
          [name, name.downcase, Jekyll::Utils.slugify(name)]
        end.uniq
        aliases = names.flat_map do |name|
          paths = ["/recipes/#{name}/", "/recipes/recipes/#{name}/"]
          # On a project site mounted at /recipes, also support the public
          # /recipes/name/ path (the canonical path for current names).
          # Alias paths here are relative to the mount.
          if !baseurl.empty?
            paths += paths.filter_map { |path| path.delete_prefix(baseurl) if path.start_with?(baseurl + '/') }
          end
          paths
        end
        aliases += Array(recipe.data['redirect_from']) # Optional exceptional aliases remain supported.
        recipe.data['redirect_from'] = aliases.uniq.reject { |path| path == recipe.url }.map do |path|
          fail_build("Redirect would replace an existing page: #{path}") if occupied.include?(path)
          if claims.key?(path) && claims[path] != recipe.url
            fail_build("Redirect #{path} points to both #{claims[path]} and #{recipe.url}")
          end
          claims[path] = recipe.url
          path
        end
      end
      retired = site.data.fetch('retired_recipe_slugs', [])
      fail_build('retired_recipe_slugs must be a list') unless retired.is_a?(Array)
      retired.each do |name|
        fail_build("Invalid retired name: #{name.inspect}") unless name.is_a?(String) && name.match?(/\A[a-z0-9][a-z0-9_-]*\z/)
        paths = ["/recipes/#{name}/", "/recipes/recipes/#{name}/"]
        paths += paths.filter_map { |path| path.delete_prefix(baseurl) if !baseurl.empty? && path.start_with?(baseurl + '/') }
        paths.uniq.each do |path|
          next if claims[path] == '/'
          fail_build("Retired route conflicts with an existing recipe: #{path}") if occupied.include?(path) || claims.key?(path)
          redirect = Jekyll::PageWithoutAFile.new(site, site.source, '', 'retired-redirect.html')
          redirect.data['permalink'] = path
          redirect.data['redirect_to'] = '/'
          site.pages << redirect
          claims[path] = '/'
        end
      end
      Jekyll.logger.info 'Recipe redirects:', "#{claims.size} aliases for #{recipes.size} recipes"
    end

    private

    def fail_build(message)
      raise Jekyll::Errors::FatalException, message
    end
  end
end

# Redirect crawlers may not follow HTML refreshes. Give the alias page the
# destination recipe's preview metadata after jekyll-redirect-from runs.
module RecipeRoutes
  class PreviewGenerator < Jekyll::Generator
    priority :lowest

    def generate(site)
      recipes = site.collections.fetch('recipes').docs.to_h { |recipe| [recipe.url, recipe] }
      baseurl = site.baseurl.to_s.sub(%r{/$}, '')
      recipes.each_value do |recipe|
        image = recipe.data['image']
        next unless image.is_a?(String) && image.start_with?('/assets/images/')
        path = site.in_source_dir(image.delete_prefix('/'))
        info = FastImage.new(path)
        next unless info.size
        recipe.data['preview_width'], recipe.data['preview_height'] = info.size
        recipe.data['preview_type'] = "image/#{info.type}" if %i[jpeg png gif webp avif].include?(info.type)
      end
      site.pages.each do |page|
        target = page.data.dig('redirect', 'to')
        next unless target
        path = URI.parse(target).path
        path = path.delete_prefix(baseurl) unless baseurl.empty?
        recipe = recipes[path]
        next unless recipe
        page.data['preview_recipe'] = recipe.data.slice('title', 'description', 'image', 'preview_width', 'preview_height', 'preview_type')
      end
    end
  end
end
