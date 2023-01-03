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

Add the following to your site's _config.yml:

```yml
plugins:
  - jekyll-generate-tags
```

## Usage

Use the following tag to reference a comma-delimited string of tag matches (in order of confidence).

```md           
{{ page.generatedtags }}
```

_Note: When building the site for the first time, it may take a bit to run through existing posts to generate each set of tags._

### Custom Labels

_Optional_: Add the following property to the `_config.yml` file to include custom labels for selection as tags.

```yml
tag_options: software engineering,coding,programming languages
```

These can also be updated in the `tag_options.txt` file within the root of the project or updated inside the gem itself.

### Confidence

By default, labels are only selected as tags if they have a greater than `.50` confidence value.

_Optional_: Add the following property to the `_config.yml` file to alter the confidence value according to desired preference.

```yml
tag_confidence: .30
```

## Caching

Includes a caching-mechanism that allows for faster re-builds when the content, labels, or confidence values don't change. The outputted tags are stored in the `.tags-cache` folder. Depending on how your site builds are handled, it probably makes sense to check this folder in to eliminate the need to reprocess each post at time of deployment.

### Clear Cache

To clear the cache entirely, simply delete the `.tags-cache` folder.
