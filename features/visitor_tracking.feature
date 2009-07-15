Feature: Psycho Visitor Tracking
  In order to see how visitors are using my site
  As a site admin
  I want to see visitors and drill down into their behavior
  
  Background:
    Given an empty tracking database
    And I am a new visitor
  
  Scenario: See list of visitors
    Given I view "/"
    And I am a new visitor
    And I view "/"
    When I view "/admin/metry"
    Then I should see "Visitor 1"
    And I should see "Visitor 2"
    
  Scenario: View visitor detail
    Given I view "/"
    And I view "/subpage"
    And I am a new visitor
    And I view "/"
    When I view "/admin/metry"
    And I follow "Visitor 1"
    Then I should see "/"
    And I should see "/subpage"