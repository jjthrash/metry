Feature: Access Tracking
  In order to how users are using my site
  As an web application creator
  I want to have all accesses to my application tracked
  
  Background:
    Given an empty tracking database
    And I am a new visitor
  
  Scenario: Single gets are tracked
    When I view "/"
    Then there should be 1 tracking entry
    
  Scenario: Multiple gets are tracked
    When I view "/"
    And I view "/"
    And I view "/"
    Then there should be 3 tracking entries
    
  Scenario: Basic request data is tracked
    When I view "/"
    And I view "/subpage"
    Then there should be a tracking entry "0":
      | key      | value    |
      | path     | /        |
      | time     | _exists_ |
    And there should be a tracking entry "1":
      | key      | value    |
      | path     | /subpage |
      | time     | _exists_ |
    
  Scenario: New visitor is tracked
    When I view "/"
    And I view "/subpage"
    Then there should be a tracking entry "0":
      | key     | value |
      | visitor | 0     |
    And there should be a tracking entry "1":
      | key     | value |
      | visitor | 0     |

  Scenario: Two visitors are tracked
    Given I view "/"
    When I am a new visitor
    Given I view "/"
    Then there should be a tracking entry "0":
      | key     | value |
      | visitor | 0     |
    And there should be a tracking entry "1":
      | key     | value |
      | visitor | 1     |
