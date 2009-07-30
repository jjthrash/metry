Feature: Psycho

  Background:
    Given I log in as an admin

  Scenario: Is Available
    When I view "/admin/metry"
    Then I should see "Visitors"
  
  Scenario: Requires login
    When I log out
    And I view "/admin/metry"
    Then I should be on "/admin/login"
