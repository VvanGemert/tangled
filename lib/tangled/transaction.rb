module Tangled
  # Transaction
  class Transaction
    attr_accessor :transaction

    def initialize(transaction)
      @transaction = transaction
    end

    def info
      {
        hash: @transaction.hash,
        tag: @transaction.tag,
        message_trytes: @transaction.signatureMessageFragment,
        address: @transaction.address,
        value: @transaction.value,
        obsolete_tag: @transaction.obsoleteTag,
        timestamp: @transaction.timestamp,
        current_index: @transaction.currentIndex,
        last_index: @transaction.lastIndex,
        bundle: @transaction.bundle,
        trunk_transaction: @transaction.trunkTransaction,
        branch_transaction: @transaction.branchTransaction,
        attachment_timestamp: @transaction.attachmentTimestamp,
        none: @transaction.nonce,
        persistence: @transaction.persistence
      }
    end

    def message
      Tangled.util.fromTrytes(
        @transaction.signatureMessageFragment.gsub(/9*$/, '')
      )
    end

    def valid?
      @transaction.valid?
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
