module Tangled
  # Transaction
  class Transaction
    def initialize(transaction)
      @transaction = transaction
    end

    def message
      Tangled.util.fromTrytes(
        @transaction.signatureMessageFragment.gsub(/9*$/, '')
      )
    end

    def hash
      @transaction.hash
    end

    def tag
      @transaction.tag
    end

    def address
      @transaction.address
    end

    def timestamp
      @transaction.timestamp
    end

    def confirmed?
      return false unless Tangled.node.synced?
      inclusion_state =
        Tangled.node.client.api.getLatestInclusion([@transaction.hash])
      return false unless inclusion_state[0]
      return true if inclusion_state[1].first
      false
    end
  end
end
