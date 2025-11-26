require "test_helper"

class MesasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mesas_index_url
    assert_response :success
  end

  test "should get new" do
    get mesas_new_url
    assert_response :success
  end

  test "should get edit" do
    get mesas_edit_url
    assert_response :success
  end
end
