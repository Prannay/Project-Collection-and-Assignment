Feature: Login

        Scenario: See Login Page
                Given I am on the home page
                When I click "Log in"
                Then I should visit the login page
