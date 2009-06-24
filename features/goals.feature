Feature: Goals
  In order to know how people are using my site
  As a site creator
  I want to be able to create goals and see when they're reached
  
  Background:
    Given no goals

  Scenario: Add goal
    When I view "/_metrics/goals"
    And I follow "Add Goal"
    And I fill in "name" with "Goal 1"
    And I fill in "path" with "/goal"
    And I press "Create"
    Then I should be on "/_metrics/goals"
    And I should see "Goal 1"
    And I should see "/goal"
    And I should see "0"
    
  Scenario: Goal visited
