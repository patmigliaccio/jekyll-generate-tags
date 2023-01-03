require 'shellwords'
require 'openssl'
require 'fileutils'

require "jekyll"
require "jekyll-generate-tags/version"

module Jekyll
  module GenerateTags
    class Error < StandardError; end

    class Generator
      @@hash_key = "cache-key"
      @@cache_folder_name = ".tags-cache"
      @@tag_options_name = "tag_options.txt"
      @@default_confidence = ".50"

      def generate_tags(content, tags, confidence)
        # Do tags exist in `_config.yml`?
        if tags.nil?
          # Look for tags in project root
          tags_path = File.expand_path(@@tag_options_name)
          if !File.exists?(tags_path)
            # Use default tags from gem
            tags_path = File.expand_path(@@tag_options_name, __dir__)
          end
          tags_file = File.read(tags_path)
          lines = tags_file.split("\n")
          tags = lines.join(",")
        end

        if confidence.nil?
          confidence = @@default_confidence
        end

        cache_key = content + tags + String(confidence)

        result = self.get_cache(cache_key)
        if result.nil?
          script_path = File.expand_path("generate.py", __dir__)
          arg1 = Shellwords.escape(content)
          arg2 = Shellwords.escape(tags)
          arg3 = Shellwords.escape(String(confidence))
          result = `python #{script_path} #{arg1} #{arg2} #{arg3}`

          self.set_cache(cache_key, result)
        end

        result
      end

      # Stores newly generated tags in a file for fast reuse
      def set_cache(key, value)
        cache_path = get_cache_file_path(key)
        # Store file
        File.open(cache_path, "w") do |file|
          file.puts(value)
        end
      end

      # Retrieves existing generated tags from a cache file for fast reuse
      def get_cache(key)
        cache_path = get_cache_file_path(key)
        # Retrieve value from file
        if File.exists?(cache_path)
          result = File.read(cache_path)
          result
        end
      end

      def create_cache_folder()
        cache_folder_path = File.expand_path(@@cache_folder_name)
        # Check if the folder exists
        if !Dir.exists?(cache_folder_path)
          # Create the folder
          FileUtils.mkdir_p(cache_folder_path)
        end
      end

      def get_cache_file_path(key)
        create_cache_folder()

        # Create the HMAC
        hmac = OpenSSL::HMAC.hexdigest('sha256', @@hash_key, key)
        cache_path = File.expand_path("#{@@cache_folder_name}/#{hmac}.txt")
        cache_path
      end
    end
  end
end
