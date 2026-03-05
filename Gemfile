source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.4'

gem 'rails', '~> 7.2.0'

# 開発・テストは SQLite（MySQL 不要でローカル動作）
gem 'sqlite3', '~> 1.4'
# 本番（Render）は PostgreSQL
gem 'pg', '~> 1.5', group: :production

gem 'puma', '~> 6.4'
gem 'sass-rails', '>= 6'
gem 'importmap-rails'
gem 'turbo-rails'

gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.2.0'
  gem 'listen', '>= 3.3'
  gem 'hotwire-livereload'
  gem 'rubocop', require: false
end

group :test do
  gem 'minitest', '~> 5.22' # Rails 7.2 と Minitest 6 の LineFiltering 互換性のため 5.x を明示
  gem 'capybara', '>= 3.38'
  gem 'selenium-webdriver'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'devise'
gem 'active_hash'
gem 'pry-rails'
gem 'ransack'
