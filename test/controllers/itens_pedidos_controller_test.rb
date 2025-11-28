require "test_helper"

class ItensPedidosControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get itens_pedidos_destroy_url
    assert_response :success
  end
end
