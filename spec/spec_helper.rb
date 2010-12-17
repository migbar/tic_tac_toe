$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'tic_tac_toe'
require 'mongo'
require 'bson_ext'



# connection = Mongo::Connection.new # (optional host/port args)
# connection.database_names.each { |name| puts name }
# connection.database_info.each { |info| puts info.inspect}
# 
# puts "*"*80
# puts "*"*80
# puts "*"*80
# puts "*"*80
# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
