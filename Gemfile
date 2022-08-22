source 'http://rubygems.org'

gem 'rails', '4.2.0'
#gem 'railties', '4.2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'pg',  '0.15.0' 
#gem 'authlogic', '2.1.6'
gem 'authlogic', '3.4.6'
gem 'i18n'
gem 'rake'
#gem 'rack'
gem 'tzinfo'
gem 'mime-types'
#gem 'polyglot'
gem 'treetop'
gem 'mail'
gem 'rack-mount'
gem 'rack-test'
gem 'thor'
gem 'date_validator'
gem 'will_paginate'



#gemas agregadas al actualizar a rails 420 (baśandose en el proyecto con rails417)
#gem 'rack' , '~> 1.5.2'
gem 'rack' , '~> 1.6'  #rails 420 depende de este
#gem 'bootstrap-sass', '~> 3.2.0.2'
gem 'bootstrap-sass', '~> 3.2.0.4'
#gem 'simple_form', '~> 3.1.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'execjs'
gem 'therubyracer'
gem 'jquery-rails', '~> 3.1.4'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'






# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
gem "capistrano-rvm"
gem "capistrano-secrets-yml"

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
group :development do
    # Deployment
    gem "capistrano", "~> 3.10", require: false
    gem "capistrano-rails", "~> 1.3", require: false
    gem 'capistrano-bundler'
  end
