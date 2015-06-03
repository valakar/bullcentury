require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "Project invalid with user and can`t be publish" do
    project = projects(:one)
    puts project.get_validation_errors
    assert_not project.valid_for_publish?
    assert_not project.publish
  end

  test "Project invalid without user and can`t be publish" do
    project = projects(:two)
    puts project.get_validation_errors
    assert_not project.valid_for_publish?
    assert_not project.publish
  end

  test "Project valid and publishing successfull" do
    project = projects(:valid)
    puts project.get_validation_errors.inspect
    assert project.valid_for_publish?
    assert project.publish
  end
end
