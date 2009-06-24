Feature: Access Tracking
  In order to how users are using my site
  As an web application creator
  I want to have all accesses to my application tracked
  
  Background:
    Given an empty tracking database
  
  Scenario: Single get
    When I view "/"
    Then I should have 1 tracking entry
    
  Scenario: Multiple gets
    When I view "/"
    And I view "/"
    And I view "/"
    Then I should have 3 tracking entries
    
  Scenario: Single Post
    When I post to "/post":
      | key | value |
      | a   | b     |
    Then I should have 1 tracking entry
    
  Scenario: Tracking entry contents
    Given I view "/"
    When I read the tracking entry "0":
      | key      | value    |
      | path     | /        |
      | time     | _exists_ |
      | visitor  | 1        |
      | referrer |          |
    
