require 'uuid'
require 'redis'

UUID.state_file = false
$uuid = UUID.new 

$redis = Redis.new
