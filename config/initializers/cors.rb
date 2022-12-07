Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*',
             methods: %i[create],
             headers: :any
  end
end
