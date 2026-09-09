# Run with: bundle exec ruby scripts/check-recipes.rb
require "yaml"
require "date"
require "uri"
root = File.expand_path("..", __dir__)
errors = []
orders = []
files = Dir[File.join(root, "_recipes", "*.md")]
files.each do |file|
  name = File.basename(file)
  begin
    front = File.read(file).split(/^---\s*$\n?/, 3)[1]
    data = YAML.safe_load(front, permitted_classes: [Date, Time])
    raise "missing title" unless data["title"].is_a?(String) && !data["title"].empty?
    raise "order must be an integer" unless data["order"].is_a?(Integer)
    orders << data["order"]
    image = data["image"]
    raise "main image must exist under assets/images/" unless image.is_a?(String) && image.start_with?("/assets/images/") && File.file?(File.join(root, image.delete_prefix("/")))
    if data.key?("ingredients") && !data["ingredients"].nil?
      raise "ingredients must be a list" unless data["ingredients"].is_a?(Array)
      data["ingredients"].each do |item|
        next if item.is_a?(String)
        raise "ingredient must be text or a text/group block" unless item.is_a?(Hash) && item["text"].is_a?(String) && !item["text"].empty?
        raise "ingredient group must be text" if item.key?("group") && !item["group"].is_a?(String)
      end
    end
    refs = data.fetch("references", [])
    raise "references must be a list" unless refs.is_a?(Array)
    ids = refs.map do |ref|
      raise "each reference needs an id, type, and label" unless ref.is_a?(Hash) && ref["id"].is_a?(String) && ref["id"].match?(/\A[a-z][a-z0-9-]*\z/) && ref["label"].is_a?(String)
      raise "unknown reference type #{ref['type']}" unless %w[image video website note].include?(ref["type"])
      if ref["type"] == "note"
        raise "note #{ref['id']} needs text" unless ref["text"].is_a?(String)
      else
        url = ref["url"]
        raise "reference #{ref['id']} needs a URL" unless url.is_a?(String)
        if url.start_with?("/assets/") && ref["type"] != "website"
          raise "missing reference file #{url}" unless File.file?(File.join(root, url.delete_prefix("/")))
        else
          parsed = URI.parse(url)
          raise "reference #{ref['id']} needs an http(s) URL or local /assets/ path" unless %w[http https].include?(parsed.scheme) && parsed.host
        end
      end
      ref["id"]
    end
    raise "reference ids must be unique" unless ids.uniq == ids
    steps = data.fetch("steps", [])
    raise "steps must be a list" unless steps.is_a?(Array)
    steps.each_with_index do |step, i|
      raise "step #{i+1} needs text" unless step.is_a?(Hash) && step["text"].is_a?(String) && !step["text"].empty?
      %w[title before after group].each {|key| raise "step #{i+1}: #{key} must be text" if step.key?(key) && !step[key].is_a?(String)}
      cites = step.fetch("citations", [])
      raise "step #{i+1}: citations must be a list" unless cites.is_a?(Array)
      inline_text = %w[before text after].map {|key| step[key].to_s}.join(" ")
      inline_ids = inline_text.scan(/\[cite:([^\]]*)\]/).flatten
      inline_ids += inline_text.scan(/\]\(#reference-([^)]*)\)/).flatten
      unknown = (cites + inline_ids) - ids
      raise "step #{i+1}: unknown citation #{unknown.join(', ')}" unless unknown.empty?
    end
    %w[method_intro method_outro].each do |key|
      unknown = data[key].to_s.scan(/\[cite:([^\]]*)\]/).flatten - ids
      raise "#{key}: unknown citation #{unknown.join(', ')}" unless unknown.empty?
    end
    %w[description method_intro method_outro].each {|key| raise "#{key} must be text" if data.key?(key) && !data[key].is_a?(String)}
  rescue StandardError => e
    errors << "#{name}: #{e.message}"
  end
end
errors << "Recipe order values must be unique and consecutive from 1 to #{files.size}" unless orders.sort == (1..files.size).to_a
abort(errors.join("\n")) unless errors.empty?
puts "Checked #{files.size} recipes: order, images, structured steps, and citation references are valid."
