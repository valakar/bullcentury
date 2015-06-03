require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "user has wright structure" do
    assert Location.attribute_names.include?("user_id")
    assert User.attribute_names.include?("image")
  end
end
