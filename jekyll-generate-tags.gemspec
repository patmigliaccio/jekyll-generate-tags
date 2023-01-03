require_relative 'lib/jekyll-generate-tags/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-generate-tags"
  spec.version       = Jekyll::GenerateTags::VERSION
  spec.authors       = ["Pat Migliaccio"]
  spec.email         = ["pat@patmigliaccio.com"]

  spec.summary       = "Classify Jekyll post content automatically using NLP"
  spec.homepage      = "https://github.com/patmigliaccio/jekyll-generate-tags"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/patmigliaccio/jekyll-generate-tags"
  spec.metadata["changelog_uri"] = "https://github.com/patmigliaccio/jekyll-generate-tags"

  spec.add_runtime_dependency "jekyll", "~> 3.9.2"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
