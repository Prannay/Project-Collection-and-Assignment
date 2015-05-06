require 'spec_helper'

RSpec.describe PreferencesController, :type => :controller do
  before(:each) do
    user = User.create(name: "David", email: "david@xyz.com", password: "1234567")
    sign_in :user
    @pro = Project.create!(title: "project1", organization: "org1", contact: "xyz", description: "abc")
  end
  describe "#create" do
    it "creates a successful preference" do
      @pref = Preference.create()
      @pref.should be_an_instance_of Preference
    end
  end
end
