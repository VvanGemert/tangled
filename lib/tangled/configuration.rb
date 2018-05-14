module Tangled
  # Config
  class Configuration
    attr_accessor :node, :version, :depth, :min_weight_magnitude

    def initialize
      @version = 1
      @node = nil
      @min_weight_magnitude = 9
      @depth = 3
    end
  end
end
