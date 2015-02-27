require 'test_helper'

class LoggerControllerTest < ActionController::TestCase
  test "should get logger" do
    get :logger
    assert_response :success
  end

end
