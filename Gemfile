source 'https://rubygems.org'
# ruby '1.9.3' # this fixes mongoid+heroku problem, in order for it to work we must gem install bundler --pre
gem 'rails', '3.2.11'
gem "mongoid"
gem 'devise', :git => 'git://github.com/plataformatec/devise.git'
gem 'kaminari'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails'
  # gem 'less-rails'
  # gem 'css_convertor'
  # gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
# gem 'wicked_pdf'
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :development do 
  gem 'rb-readline'
end
group :test do 
  gem 'factory_girl_rails'
end