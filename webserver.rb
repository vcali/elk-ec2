require 'sinatra'

set :bind, '0.0.0.0'
set :port, 8080

# A little trick to get Sinatra writting on both stdout and a log file
configure do
	file = File.new("/var/log/webserver.log", 'a+')
	file.sync = true
	use Rack::CommonLogger, file
end

get '/fender' do
	'Hello Fender and Riffstation !!!'
end

