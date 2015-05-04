class AssignmentsController < ApplicationController
  
  def assign
  	@projects = Project.where("approved = ?", true)
  	@prefs = Preferences.all

  	# Create Graph Here

  	# Run Matching Algorithm

  	# Render/Store Reults
  end
end
