require 'iota'
require 'string'

require 'tangled/version'
require 'tangled/configuration'
require 'tangled/seed'
require 'tangled/node'
require 'tangled/account'
require 'tangled/transfer'
require 'tangled/transaction'
require 'tangled/stream'

require 'tangled/multisig'

# Tangled
module Tangled
  class << self
    attr_accessor :configuration
  end

  def self.node
    Node.new(configuration.node)
  end

  def self.account(seed = Seed.generate)
    Account.new(seed)
  end

  def self.generate_seed
    Seed.generate
  end

  def self.util
    @util ||= IOTA::Utils::Utils.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.stream
    Stream.new
  end
end
