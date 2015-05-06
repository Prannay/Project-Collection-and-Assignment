Feature: Help

	Scenario: See Help Page
		Given I am on the home page
		When I click "Help"
		Then I should visit the help page
