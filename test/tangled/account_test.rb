require 'test_helper'

class AccountTest < Minitest::Test
  def setup
    @seed = Tangled.generate_seed
    @account = Tangled.account(@seed)
  end

  def test_if_account_info_exists
    assert_equal @account.info[:balance], 0
    assert_equal @account.info[:transfers], []
  end

  def test_adding_a_address
    address = @account.add_address
    assert address.size, 81
    assert_equal @account.info[:addresses].size, 2
  end

  def test_transferring_a_message
    seed_to = Tangled.generate_seed
    account_to = Tangled.account(seed_to)

    address = account_to.add_address
    @account.transfer(address, 'tangled')

    assert_equal account_to.transfers.last.transactions.first.message, 'tangled'
  end
end
