Rails.application.configure do
  config.action_mailer.default_url_options = { host: Settings.host, port: Settings.port || 80}
end
