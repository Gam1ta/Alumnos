require 'test_helper'

class FichasEstatusControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
