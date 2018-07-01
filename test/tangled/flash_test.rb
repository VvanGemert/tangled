require 'test_helper'

class FlashTest < Minitest::Test
  DEPOSITS = [1000, 1000]
  CHANNEL_BALANCE = 2000
  TREE_DEPTH = 4
  SIGNERS_COUNT = 2
  SECURITY = 2

  ONE_SETTLEMENT_ADDRESS = "USERONE9ADDRESS9USERONE9ADDRESS9USERONE9ADDRESS9USERONE9ADDRESS9USERONE9ADDRESS9U"
  TWO_SETTLEMENT_ADDRESS = "USERTWO9ADDRESS9USERTWO9ADDRESS9USERTWO9ADDRESS9USERTWO9ADDRESS9USERTWO9ADDRESS9U"


  def setup
    @multisig = Tangled::Multisig.new
    @user_one = {
      user_index: 0,
      user_seed: "USERONEUSERONEUSERONEUSERONEUSERONEUSERONEUSERONEUSERONEUSERONEUSERONEUSERONEUSER",
      index: 0,
      security: SECURITY,
      depth: TREE_DEPTH,
      bundles: [],
      partial_digests: [],
      flash: {
        signers_count: SIGNERS_COUNT,
        balance: CHANNEL_BALANCE,
        deposit: DEPOSITS.dup,
        outputs: {},
        transfers: [],
        settlement_addresses: [ONE_SETTLEMENT_ADDRESS, TWO_SETTLEMENT_ADDRESS]
      }
    }

    @user_two = {
      user_index: 1,
      user_seed: "USERTWOUSERTWOUSERTWOUSERTWOUSERTWOUSERTWOUSERTWOUSERTWOUSERTWOUSERTWOUSERTWOUSER",
      index: 0,
      security: SECURITY,
      depth: TREE_DEPTH,
      bundles: [],
      partial_digests: [],
      flash: {
        signers_count: SIGNERS_COUNT,
        balance: CHANNEL_BALANCE,
        deposit: DEPOSITS.dup,
        outputs: {},
        transfers: [],
        settlement_addresses: [ONE_SETTLEMENT_ADDRESS, TWO_SETTLEMENT_ADDRESS]
      }
    }
  end

  def test_if_node_info_exists

    # Make an array of digests
    all_digests = create_digests

    # Create multisigs
    one_multisigs = create_multisigs(@user_one, all_digests)
    two_multisigs = create_multisigs(@user_two, all_digests)

    # Set remainder addresses
    @user_one[:flash][:remainder_address] = one_multisigs.shift
    @user_two[:flash][:remainder_address] = two_multisigs.shift

    # TODO: Nest Trees

    # Set Flash root
    @user_one[:flash][:root] = one_multisigs.shift
    @user_two[:flash][:root] = two_multisigs.shift

    # Set settlement addresses
    # Done in original loop

    # Set digest/key index
    @user_one[:index] = @user_one[:partial_digests].size
    @user_two[:index] = @user_two[:partial_digests].size

    p @user_one
  end

  def create_digests
    TREE_DEPTH.times.each do |i|
      digest = @multisig.get_digest(
        @user_one[:user_seed],
        @user_one[:index],
        @user_one[:security]
      )
      @user_one[:index] += 1
      @user_one[:partial_digests].push(digest)

      digest = @multisig.get_digest(
        @user_two[:user_seed],
        @user_two[:index],
        @user_two[:security]
      )
      @user_two[:index] += 1
      @user_two[:partial_digests].push(digest)
    end

    {
      @user_one[:user_index] => @user_one[:partial_digests],
      @user_two[:user_index] => @user_two[:partial_digests]
    }
  end

  def create_multisigs(user, all_digests)
    user[:partial_digests].map.with_index do |digest, index|
      addy = @multisig.compose_address(
        all_digests.map { |v| v.last[index] }
      )

      addy[:index] = digest[:index]
      addy[:signing_index] = user[:user_index] * digest[:security]
      addy[:security_sum] = all_digests.map { |k| k.last[index][:security] }.sum
      addy[:security] = digest[:security]
      addy
    end
  end
end
