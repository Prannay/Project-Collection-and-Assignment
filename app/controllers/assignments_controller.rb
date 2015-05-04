class AssignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def assign
  	@projects = Project.where("approved = ?", true)
  	@prefs = Preference.all

  	# Create Graph Here

  	# Run Matching Algorithm

  	# Render/Store Reults
  end
end
