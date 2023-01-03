# frozen-string-literal: true

require "jekyll"
require "jekyll-generate-tags/generator"

# register the generate_tags method as a Jekyll hook
Jekyll::Hooks.register :site, :pre_render do |site, payload|
  generator = Jekyll::GenerateTags::Generator.new

  tag_options = site.config["tag_options"]
  tag_confidence = site.config["tag_confidence"]

  posts = payload["site"]["posts"]
  posts.each do |post|
    post_name = File.basename(post.path, '.md')

    tags = generator.generate_tags(post.content, tag_options, tag_confidence)
  
    # add the generated tags to the document's front matter
    post.data["generatedtags"] = tags
  end
end
