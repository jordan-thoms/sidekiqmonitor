# this code goes in your config.ru
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require 'sidekiq/web'
map '/' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'sidekiq' && password == (ENV["SIDEKIQ_PASSWORD"] || "sidekiq")
  end
  use Rack::Session::Cookie, :secret => (ENV['SIDEKIQ_SECRET'] || 'zzz')
  run Sidekiq::Web
end
