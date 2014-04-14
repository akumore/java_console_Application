Airbrake.configure do |config|
  if Rails.env.production?
    config.api_key    = '527399de-b43d-4000-9408-a44c8ea2213b'
  else
    config.api_key    = '1a1354cd-d507-4d47-8078-8797d6f146f3'
  end
  config.host       = 'apps.screenconcept.ch'
  config.port       = 80
end
