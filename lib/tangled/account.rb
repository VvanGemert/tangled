module Tangled
  # Account
  class Account
    def initialize(seed)
      @seed = seed
      @account ||= IOTA::Models::Account.new(Tangled.node.client, seed)
    end

    def info
      details = @account.getAccountDetails
      {
        balance: details.balance,
        transfers: details.transfers,
        latest_address: details.latestAddress,
        addresses: details.addresses,
        inputs: details.inputs
      }
    end

    def add_address
      address = @account.getNewAddress
      transfer(address) # Add address to Tangle
      address
    end

    def transfer(address, message = nil, value = 0)
      transfers = [{
        address: address,
        value: value,
        message: Tangled.util.toTrytes(message)
      }]
      depth = 3
      min_weight_magnitude = 9
      @account.sendTransfer(depth, min_weight_magnitude, transfers)
    end

    def transfers
      info[:transfers].map do |transfer|
        Transfer.new(transfer)
      end
    end
  end
end
