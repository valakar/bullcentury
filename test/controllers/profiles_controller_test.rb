require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "edit profile not logined user" do
    get(:edit, {:id => 1})

    assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
  end

  test "user logined but edit not self profile " do
    user_one = users(:one)
    user_two = users(:two)

    sign_in(user_one)
    get(:edit, {:id => user_two.id})

    assert_redirected_to root_path
    assert_equal 'You have no rights to do that', flash[:error]

    sign_out(user_one)
  end

  test "user logined and edit self profile " do
    user_one = users(:one)
    sign_in(user_one)
    get(:edit, {:id => user_one.id})
    
    assert assigns(:user) == user_one
    sign_out(user_one)
  end
end

  # assert_difference('Post.count') do
  #   post :create, post: {title: 'Some title'}
  # end
  # get(:show, {'id' => "12"}, {'user_id' => 5})
  # assert_redirected_to post_path(assigns(:post))


  #   assigns - Any objects that are stored as instance variables in actions for use in views.
  #   cookies - Any cookies that are set.
  #   flash - Any objects living in the flash.
  #   session - Any object living in session variables.
