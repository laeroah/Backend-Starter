if Rails.env.development? || Rails.env.staging?
  Rails.application.config.middleware.insert_before 0, 'Rack::Cors' do
    allow do
      origins 'local.example.com:3000'
      resource '*', headers: :any, methods: [:get, :post, :options, :put]
    end
  end
end
