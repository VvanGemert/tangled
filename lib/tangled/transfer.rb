module Tangled
  # Transfer
  class Transfer
    def initialize(transfer)
      @transfer = transfer
    end

    def transactions
      @transfer.transactions.map do |transaction|
        Transaction.new(transaction)
      end
    end
  end
end
