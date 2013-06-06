source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'json', '~> 1.7.7'

group :development do
  gem 'pg'
  gem 'pry-rails'
end

group :production do
  gem 'thin'
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'shoulda'
end

# jQuery
gem 'jquery-rails'

# Configuration File
gem 'rails_config'

# Rails Admiin
gem 'rails_admin'

gem "devise"

# Stripe
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

# Figaro for configuring env variables
gem 'figaro'
