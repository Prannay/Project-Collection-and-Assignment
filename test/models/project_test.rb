require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@p = Project.new(title: "Example Project", organization: "CSE", contact: "abc", description:"what", oncampus: true, islegacy: false)
  end

  test "should be valid" do
  	assert @p.valid?
  end

  test "title should be present" do
  	@p.title = "    "
  	assert_not @p.valid?
  end

  test "org should be present" do
  	@p.organization = "   "
  	assert_not @p.valid?
  end
end
