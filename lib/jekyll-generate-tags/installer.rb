require "rubygems/installer"

module Jekyll
  class Installer < Gem::Installer
    def install
      # install the Python packages from the requirements.txt file
      system "pip install -r #{File.join(gem_dir, "requirements.txt")}"
    end
  end
end