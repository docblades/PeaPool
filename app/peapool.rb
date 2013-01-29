require 'sinatra/base'
require './config/default.rb'
require 'redis'
require 'uuid'
require 'uri'

class PeaPool < Sinatra::Base
  
  helpers do
    def base_url
      "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def uuid
      return @uuid if defined? @uuid

      UUID.state_file = false
      @uuid = UUID.new
    end

    def redis
      return @redis if defined? @redis

      if ENV['REDISTOGO_URL']
        uri = URI.parse(ENV['REDISTOGO_URL'])
        @redis = Redis.new(:host => uri.host,
                           :port => uri.port,
                           :password => uri.password)
      else
        @redis = Redis.new
      end
      
    end

    def four_oh_four
      status 404
      File.read(File.join(File.dirname(__FILE__), "..", "static", "404.html"))
    end

    def gamekey(gamecode = nil)
      gamecode = params[:game_code] unless gamecode
      "game:#{gamecode}"
    end

    def game_full
      status 400
      erb :game_full
    end
  end
    
  get '/' do
    erb :index, :locals => {:active_games => redis.keys("game:*").count }
  end

  get '/game/:game_code/share' do
    game_url = "#{base_url}/game/#{params[:game_code]}"
    erb :qrcode, :locals => { :gamecode => params[:game_code], :game_url => game_url }
  end

  get '/game/new' do
    game_code = uuid.generate
    
    success = redis.multi do
      redis.sadd gamekey(game_code), nil
      redis.srem gamekey(game_code), nil
      redis.expire gamekey(game_code), 10 * 60
    end
    
    if success
      redirect to("/game/#{game_code}/draw"), "Wooo"
    else
      raise "something went badly with redis"
    end
  end

  get '/game/:game_code/draw' do
    taken = redis.smembers gamekey
    pea = ((1..15).to_a - taken.map{|x| x.to_i}).sample

    game_full unless pea
    
    success = redis.multi do
      redis.sadd gamekey, pea
      redis.expire gamekey, 10 * 60
    end

    raise "something's gone wrong" unless success

    status 201
    erb :pea, :locals => { :pea => pea, :gamecode => params[:game_code] }
  end

  get '/game/:game_code' do
    unless redis.exists gamekey
      four_oh_four
    else
      player_count = redis.smembers(gamekey).count
      erb :game, :locals => {:player_count => player_count, :gamecode => params[:game_code]}
    end    
  end

end
