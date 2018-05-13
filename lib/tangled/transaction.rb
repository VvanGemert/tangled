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
  end
end
