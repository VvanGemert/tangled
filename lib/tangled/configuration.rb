module Tangled
  # Config
  class Configuration
    attr_accessor :node, :version

    def initialize
      @version = 1
      @node = nil
    end
  end
end
