module Tangled
  # Node
  class Node
    attr_accessor :url, :client

    def initialize(node_url)
      @url = node_url
      @client = IOTA::Client.new(provider: node_url)
    end

    def info
      node_info = @client.api.getNodeInfo
      return :failed unless node_info[0]
      node_info = node_info[1].each_with_object({}) do |(k, v), x|
        x[k.snakecase] = v
      end
      node_info
    end

    def neighbors
      neighbors = @client.api.getNeighbors
      return :failed unless neighbors[0]
      neighbors[1]
    end

    def synced?
      status = info
      return false \
        if status['latest_milestone'] !=
           status['latest_solid_subtangle_milestone']
      return false \
        if status['latest_milestone_index'] !=
           info['latest_solid_subtangle_milestone_index']
      true
    end
  end
end
