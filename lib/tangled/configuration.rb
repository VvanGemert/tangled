module Tangled
  # Config
  class Configuration
    attr_accessor :node, :version, :depth, :min_weight_magnitude, :stream_url

    def initialize
      @version = 1
      @node = nil
      @min_weight_magnitude = 9
      @depth = 3
      @stream_url = nil
    end
  end
end
