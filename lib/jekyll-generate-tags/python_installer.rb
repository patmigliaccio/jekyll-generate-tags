require "rubygems/installer"

module JekyllGenerateTags
  class PythonInstaller < Gem::Installer
    def install
      # install the Python packages from the requirements.txt file
      system "pip install -r #{File.join(gem_dir, "requirements.txt")}"
    end
  end
end