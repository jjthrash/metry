Feature: Basic Sinatra application works
  In order to test rack middleware
  As a middleware creator
  I want an example application that I can test against
  
  Scenario: Get root
    When I view "/"
    Then I should see "Root"

  Scenario: Get subpage
    When I view "/subpage"
    Then I should see "Sub page"