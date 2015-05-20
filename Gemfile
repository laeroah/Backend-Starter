source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'slim-rails'

# oauth 流程
gem 'doorkeeper'

# 邮件发送
gem 'mailgun_rails'

# 用户登录
gem 'devise'

# json解析
gem 'multi_json'

# 程序参数配置
gem 'settingslogic'

# 服务运行情况统计
gem 'newrelic_rpm'

# 防攻击
gem 'rack-attack'

# http服务调用相关
gem 'rest-client'
gem 'httpi'
gem 'curb'

# api 文档
gem 'apipie-rails'

# heroku 部署相关
gem 'foreman'
gem 'rails_12factor'

# 上传和图片处理
gem 'carrierwave'
gem 'mini_magick'

# soap client
gem 'savon'

# 非数字友好ID
gem 'friendly_id'

# 状态机
gem 'aasm'

# 异常通知
gem 'exception_notification'

# 允许跨域
gem 'rack-cors', require: 'rack/cors'

# xml处理
gem 'nokogiri'

# javascript相关
gem "bower-rails", "~> 0.9.2"

group :production, :staging do
  # http服务
  gem 'puma'

  # mysql驱动
  gem 'mysql2'
end

group :development, :test do
  gem 'sqlite3'

  # 测试相关
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'

  # 测试 http mock
  gem 'webmock'

  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'

  # 调试相关
  gem 'awesome_print'
  gem 'pry-rails'

  # 服务自动更新
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'guard-migrate'

  # 邮件本地测试
  gem 'letter_opener'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
end

