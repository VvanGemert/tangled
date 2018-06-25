module Tangled
  # Multisig
  class Multisig
    def initialize
      @client = IOTA::Client.new(provider: 'https://nodes.testnet.iota.org:443')
      @multisig = IOTA::Multisig::Multisig.new(@client)
    end

    def get_digest(seed, index, security)
      {
        digest: @multisig.getDigest(
          seed, index, security
        ),
        security: security,
        index: index
      }
    end

    def compose_address(digests)
      multisig = initialize_address(digests)
      finalize_address(multisig)
    end

    def initialize_address(digests)
      address = IOTA::Multisig::Address.new(digests.map { |k| k[:digest] })
      multisig = {
        address: address,
        security_sum: 0,
        children: [],
        bundles: []
      }
      absorb_address_digests(multisig, digests) if digests
      multisig
    end

    def absorb_address_digests(multisig, digests)
      to_absorb = digests.map { |k| k[:digest] }
      multisig[:address] = multisig[:address].absorb(to_absorb)
      multisig[:security_sum] += digests.map { |k| k[:security] }.sum
      multisig
    end

    def finalize_address(multisig)
      raise 'Could not finalize address' if multisig[:security_sum] <= 0
      multisig[:address] = multisig[:address].finalize
      multisig
    end
  end
end
