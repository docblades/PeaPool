require 'sinatra/base'
require './config/default.rb'

class PeaPool < Sinatra::Base
  
  get '/' do
    "Hello, World"
  end
  
  run! if app_file = $0
end
