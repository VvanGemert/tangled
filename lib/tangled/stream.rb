require 'ffi-rzmq'

module Tangled
  # Stream
  class Stream
    def run
      context = ZMQ::Context.new
      subscriber = context.socket ZMQ::SUB
      subscriber.connect 'tcp://localhost:5556'
      subscriber.setsockopt ZMQ::SUBSCRIBE, 'tx'

      trap('INT') do
        puts ''
        puts 'Stopping stream.'
        subscriber.close
        context.terminate
        exit
      end

      start_loop(subscriber)
    end

    def start_loop(subscriber)
      loop do
        transaction = ''
        subscriber.recv_string(transaction)
        subscriber.recv_string(_transaction_trytes = '')

        data = parse_transaction(transaction)
        puts data
      end
    end

    def parse_transaction(transaction)
      data = transaction.split(' ')
      keys = %i[tx hash address value tag timestamp bundle_index
                transactions_in_bundle bundle_hash branch_transaction_hash
                branch_transaction_hash attachment_timestamp]

      trans_hash = Hash[*keys.zip(data).flatten]
      trans_hash.each do |k, v|
        trans_hash[k] = v.to_i \
          if %i[value bundle_index transactions_in_bundle].include?(k)
      end
      trans_hash
    end
  end
end
