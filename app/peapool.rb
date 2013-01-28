require 'sinatra/base'
require './config/default.rb'

class PeaPool < Sinatra::Base

  helpers do
    def base_url
      "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end
  end
    
  get '/' do
    "Hello, World"
  end

  get '/game/:game_code/share' do
    game_url = "#{base_url}/game/#{params[:game_code]}"
    erb :qrcode, :locals => { :gamecode => game_url }
  end
  
  run! if app_file = $0
end
