Feature: Add Project

	Scenario: See Add Project Page
		Given I am on the home page
		When I click "Add Project"
		Then I should visit the add_project page
