$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'tangled'
require 'byebug'

require 'minitest/autorun'

Tangled.configure do |config|
  config.node = 'https://nodes.testnet.iota.org:443'
end
