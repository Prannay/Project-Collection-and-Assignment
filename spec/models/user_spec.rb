require 'spec_helper'

describe User, :type => :model do
  it "should create a new instance of a user given valid attributes" do
    User.create!(name: "David", email: "david@xyz.com", password: "1234567")
    User.create!(name: "Andy", email: "andy@xyz.com", password: "1234567")
  end
end
