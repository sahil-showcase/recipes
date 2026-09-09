# Verify real generated pages as well as the complete historical route inventory.
require 'json'
require 'yaml'
require 'uri'
require 'nokogiri'
root = File.expand_path('..', __dir__)
output = File.expand_path(ARGV.fetch(0, '_site'))
baseurl = ARGV.fetch(1, '').sub(%r{/$}, '')
redirects = JSON.parse(File.read(File.join(output, 'redirects.json')))
history = YAML.safe_load(File.read(File.join(root, '_data/legacy_recipe_slugs.yml')))
raise 'No generated redirects; custom plugin may not have loaded' if redirects.empty?
page_cache = {}
redirects.each do |from, to|
  target = URI.parse(to).path
  raise "Target outside site base path: #{to}" unless baseurl.empty? || target.start_with?(baseurl + '/')
  target = target.delete_prefix(baseurl) unless baseurl.empty?
  raise "Redirect chain or loop: #{from}" if redirects.key?(target)
  target_file = File.join(output, target.delete_prefix('/'), 'index.html')
  raise "Missing recipe for #{from}: #{target}" unless File.file?(target_file)
  target_html = page_cache[target_file] ||= File.read(target_file)
  marker = target == '/' ? 'recipe-grid' : 'recipe-content'
  raise "Target does not render recipe content: #{target}" unless target_html.include?(marker)
  html = Nokogiri::HTML(File.read(File.join(output, from.delete_prefix('/'), 'index.html')))
  raise "Missing redirect refresh: #{from}" unless html.at_css('meta[http-equiv="refresh"]')
  raise "Wrong redirect canonical: #{from}" unless html.at_css('link[rel="canonical"]')['href'] == to
  unless target == '/'
    destination = Nokogiri::HTML(target_html)
    %w[og:title og:image og:image:width og:image:height og:image:type og:url].each do |property|
      expected = destination.at_css("meta[property='#{property}']")&.[]('content')
      actual = html.at_css("meta[property='#{property}']")&.[]('content')
      raise "Missing or mismatched #{property} on #{from}" unless expected && actual == expected
    end
  end
end
home = Nokogiri::HTML(File.read(File.join(output, 'index.html')))
Dir[File.join(root, '_recipes/*.md')].each do |file|
  name = File.basename(file, '.md')
  target = baseurl + "/#{name}/"
  raise "Homepage does not link directly to #{target}" unless home.at_css(".recipe-card a[href='#{target}']")
  recipe_html = Nokogiri::HTML(File.read(File.join(output, name, 'index.html')))
  canonical = recipe_html.at_css('link[rel="canonical"]')&.[]('href')
  raise "Incorrect canonical recipe URL: #{name}" unless canonical && URI.parse(canonical).path == target
  hero = recipe_html.at_css('.hero-image img')&.[]('src')
  image = recipe_html.at_css('meta[property="og:image"]')&.[]('content')
  raise "Preview image does not match hero: #{name}" unless hero && image == URI.join(canonical, hero).to_s
  raise "Image URL is not absolute: #{name}" unless URI.parse(image).is_a?(URI::HTTP)
  expected = ["/recipes/#{name}/", "/recipes/recipes/#{name}/"]
  expected << "/#{name}/" if baseurl == '/recipes'
  history.fetch(name, []).each do |old|
    expected.concat(["/recipes/#{old}/", "/recipes/recipes/#{old}/"])
    expected << "/#{old}/" if baseurl == '/recipes'
  end
  expected.uniq.each do |path|
    next if baseurl + path == target
    raise "Uncovered historical URL: #{baseurl}#{path}" unless redirects.key?(path) && URI.parse(redirects[path]).path == target
  end
end
YAML.safe_load(File.read(File.join(root, '_data/retired_recipe_slugs.yml'))).each do |name|
  paths = ["/recipes/#{name}/", "/recipes/recipes/#{name}/"]
  paths << "/#{name}/" if baseurl == '/recipes'
  paths.each do |path|
    raise "Retired route not covered: #{path}" unless redirects.key?(path) && URI.parse(redirects[path]).path == baseurl + '/'
  end
end
%w[vendor Gemfile Gemfile.lock NEW-RECIPE-TEMPLATE.html NEW-RECIPE-TEMPLATE.md scripts/check-recipes.rb test/recipe_redirects_test.rb].each do |file|
  raise "Development file published: #{file}" if File.exist?(File.join(output,file))
end
puts "Verified #{redirects.size} redirect pages and every historical name (baseurl=#{baseurl.inspect})."
