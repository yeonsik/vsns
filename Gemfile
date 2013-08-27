source 'https://rubygems.org'

ruby "2.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Attention! added by hschoi
# To resolve Turbolink problems, 
# please reference http://blog.joshsoftware.com/2013/06/28/troubleshooting-turbolinks-with-rails-4/.
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'less-rails'
gem "twitter-bootstrap-rails"

# commented out by hschoi due to incompatibility to summernote-rails
# gem 'flatui-rails'
gem 'summernote-rails'

gem 'slimbox2-rails'

gem 'simple_form', github: 'plataformatec/simple_form', tag: 'v3.0.0.rc'

# gem 'carrierwave'
gem 'carrierwave-aws'  # added by hschoi

gem 'rmagick'

gem 'devise', github: 'plataformatec/devise', branch: 'rails4'

gem 'will_paginate'
gem 'pageless-rails', github: 'rorlab/pageless-rails'
gem 'acts-as-taggable-on'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
