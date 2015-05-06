require 'spec_helper'

RSpec.describe RelationshipsController, :type => :controller do
  before(:each) do
    user = User.create(name: "David", email: "david@xyz.com", password: "1234567")
    sign_in :user
  end
  describe "#create" do
    it "creates a successful relationships" do
      @rel = Relationship.create()
      @rel.should be_an_instance_of Relationship
    end
  end
end
