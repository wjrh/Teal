require 'test_helper'

class EpisodesControllerTest < ActionController::TestCase
  test "should get episodes" do
    get :episodes
    assert_response :success
  end

end
