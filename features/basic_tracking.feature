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
      | key          | value    |
      | metrics.path | /        |
      | metrics.time | _exists_ |
    And there should be a tracking entry "1":
      | key          | value    |
      | metrics.path | /subpage |
      | metrics.time | _exists_ |
    
  Scenario: New visitor is tracked
    When I view "/"
    And I view "/subpage"
    Then there should be a tracking entry "0":
      | key             | value |
      | metrics.visitor | 0     |
    And there should be a tracking entry "1":
      | key             | value |
      | metrics.visitor | 0     |

  Scenario: Two visitors are tracked
    Given I view "/"
    When I am a new visitor
    Given I view "/"
    Then there should be a tracking entry "0":
      | key             | value |
      | metrics.visitor | 0     |
    And there should be a tracking entry "1":
      | key             | value |
      | metrics.visitor | 1     |
      
  Scenario: All facets should be tracked
    When I view "/"
    Then there should be a tracking entry "0":
      | key          | value       |
      | metrics.path | /           |
      | metrics.time | _exists_    |
      | metrics.ip   | 127.0.0.1   |
      | metrics.host | example.org |

  Scenario: path should include query string
    When I view "/?here=there"
    Then there should be a tracking entry "0":
      | key          | value        |
      | metrics.path | /?here=there |
      
  Scenario: Should track status codes
    When I view "/"
    And I view "/missing"
    Then there should be a tracking entry "0":
      | key            | value |
      | metrics.status | 200   |
    Then there should be a tracking entry "1":
      | key            | value |
      | metrics.status | 404   |

  Scenario: Should track method
    When I view "/"
    And I post to "/post":
      | key   | value |
      | bogus | bogus |
    Then there should be a tracking entry "0":
      | key            | value |
      | metrics.method | GET   |
    Then there should be a tracking entry "1":
      | key            | value |
      | metrics.method | POST  |
