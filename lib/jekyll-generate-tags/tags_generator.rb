require 'shellwords'
require 'openssl'
require 'fileutils'

require "jekyll"
require "jekyll-generate-tags/version"

module JekyllGenerateTags
  class Error < StandardError; end

  class TagsGenerator
    @@hash_key = "cache-key"
    @@cache_folder_name = ".tags-cache"

    def generate_tags(content, tags, confidence)
      if tags.nil?
        tags_path = File.expand_path("tag_options.txt", __dir__)
        tags_file = File.read(tags_path)
        lines = tags_file.split("\n")
        tags = lines.join(",")
      end

      if confidence.nil?
        confidence = ".50"
      end

      cache_key = content + tags + confidence

      result = self.get_cache_tags(cache_key)
      if result.nil?
        script_path = File.expand_path("generate.py", __dir__)
        arg1 = Shellwords.escape(content)
        arg2 = Shellwords.escape(tags)
        arg3 = Shellwords.escape(confidence)
        result = `python #{script_path} #{arg1} #{arg2} #{arg3}`

        self.set_cache_tags(cache_key, result)
      end

      result
    end

    # Stores newly generated tags in a file for fast reuse
    def set_cache_tags(key, value)
      cache_folder_path = File.expand_path(@@cache_folder_name, __dir__)
      # Check if the folder exists
      if !Dir.exists?(cache_folder_path)
        # Create the folder
        FileUtils.mkdir_p(cache_folder_path)
      end

      # Create the HMAC
      hmac = OpenSSL::HMAC.hexdigest('sha256', @@hash_key, key)
      cache_path = File.expand_path("#{@@cache_folder_name}/#{hmac}.txt", __dir__)
      # Store file
      File.open(cache_path, "w") do |file|
        file.puts(value)
      end
    end

    # Retrieves existing generated tags from a cache file for fast reuse
    def get_cache_tags(key)
      cache_folder_path = File.expand_path(@@cache_folder_name, __dir__)
      # Check if the folder exists
      if !Dir.exists?(cache_folder_path)
        # Create the folder
        FileUtils.mkdir_p(cache_folder_path)
      end

      # Create the HMAC
      hmac = OpenSSL::HMAC.hexdigest('sha256', @@hash_key, key)
      cache_path = File.expand_path("#{@@cache_folder_name}/#{hmac}.txt", __dir__)
      # Retrieve value from file
      if File.exists?(cache_path)
        result = File.read(cache_path)
        result
      end
    end
  end
end

generator = TagsGenerator.new

# register the generate_tags method as a Jekyll hook
Jekyll::Hooks.register :site, :pre_render do |site, payload|
  tags = ""
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
