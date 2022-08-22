require 'test_helper'

class HorariosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
