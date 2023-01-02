# jekyll-generate-tags

Classify Jekyll post content automatically using NLP ([huggingface.co/facebook/bart-large-mnli](https://huggingface.co/facebook/bart-large-mnli)) based on a set of site-wide labels.

## Installation

### Prerequisites

* Python

### Install

Add this line to your project's Gemfile:

```ruby
gem 'jekyll-generate-tags'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-generate-tags

## Usage

```md           
{{ page.generatedtags }}
```

### Custom Labels

_Optional_: Add the following property to the `_config.yml` file to include custom labels for selection as tags.

```yml
tag_options: software engineering,coding,programming languages
```

These can also be updated in the `tag_options.txt` file instead.

### Confidence

By default, labels are only selected as tags if they have a greater than `.50` confidence value.

_Optional_: Add the following property to the `_config.yml` file to alter the confidence value according to desired preference.

```yml
tag_confidence: .30
```

## Caching

Includes a caching-mechanism that allows for faster re-builds when content, labels or confidence value doesn't change.

### Clear Cache

To clear the cache entirely, simply delete the `.tags-cache` folder.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patmigliaccio/jekyll-generate-tags.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).