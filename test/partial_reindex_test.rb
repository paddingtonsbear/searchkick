require_relative "test_helper"

class PartialReindexTest < Minitest::Test
  def test_basic
    store [{name: "Hi", color: "Blue"}]

    # normal search
    assert_search "hi", ["Hi"], fields: [:name], load: false
    assert_search "blue", ["Hi"], fields: [:color], load: false

    # update
    Product.first.update_columns(name: "Bye", color: "Red")
    Product.searchkick_index.refresh

    # index not updated
    assert_search "hi", ["Hi"], fields: [:name], load: false
    assert_search "blue", ["Hi"], fields: [:color], load: false

    # partial reindex
    Product.partial_reindex(:search_name)

    # name updated, but not color
    assert_search "bye", ["Bye"], fields: [:name], load: false
    assert_search "blue", ["Bye"], fields: [:color], load: false
  end

  def test_with_instance_method
    store [{name: "Hi", color: "Blue"}]

    # normal search
    assert_search "hi", ["Hi"], fields: [:name], load: false
    assert_search "blue", ["Hi"], fields: [:color], load: false

    # update
    product = Product.first
    product.update_columns(name: "Bye", color: "Red")
    Product.searchkick_index.refresh

    # index not updated
    assert_search "hi", ["Hi"], fields: [:name], load: false
    assert_search "blue", ["Hi"], fields: [:color], load: false

    product.partial_reindex(:search_name)

    # name updated, but not color
    assert_search "bye", ["Bye"], fields: [:name], load: false
    assert_search "blue", ["Bye"], fields: [:color], load: false
  end
end
