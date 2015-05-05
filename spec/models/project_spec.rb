require 'spec_helper'

describe Project, :type => :model do
  it "should create a new project given valid attributes" do
    Project.create!(title: "project1", organization: "org1", contact: "xyz", description: "abc")
    Project.create!(title: "project2", organization: "org2", contact: "xyz", description: "abc")
  end
end
