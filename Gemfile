source 'https://rubygems.org'

gem 'rails'
gem 'jquery-rails'
# gem 'jquery-ui-rails'
gem 'haml-rails'

## authentication ##
# gem 'devise'
# gem "cancan"

## mongo ##
gem "mongoid", "~> 3.0.0"
# gem 'bson',     require: false  
# gem 'bson_ext', require: false

gem 'oj'            # a fast JSON parser
gem 'multi_json'    # JSON encoder selector
gem 'draper'
gem 'puma'

gem 'qu-rails'
gem 'qu-redis'

gem 'clockwork'

# gem 'rabl'          # Rails API language
# gem 'fnordmetric'

gem "activeadmin-mongoid",  git: "git://github.com/elia/activeadmin-mongoid.git"
gem 'devise'
gem 'pry-rails'

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "rainbow"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem "angular-rails"
  # gem 'batman-rails'
  gem 'coffee-rails', '~> 3.2.1'
  # gem 'normalize-rails'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
  gem 'twitter-bootstrap-rails'

  # gem 'haml_assets' # allows .haml to be read from the asset pipeline (for JS frameworks)
  # gem 'coffee-filter' # allows a :coffeescript tag for inline coffeescript

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end
