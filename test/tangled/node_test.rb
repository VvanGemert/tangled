require 'test_helper'

class NodeTest < Minitest::Test
  def test_if_node_is_synced
    assert Tangled.node.synced?
  end

  def test_if_node_info_exists
    status = Tangled.node.info
    assert_equal 'IRI Testnet', status['app_name']
    assert status['tips'] > 0
  end
end
