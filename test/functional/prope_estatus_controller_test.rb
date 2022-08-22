require 'test_helper'

class PropeEstatusControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
