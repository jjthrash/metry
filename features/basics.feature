Feature: Basics Work
  In order to test rack middleware
  As a middleware creator
  I want an example application that I can test against
  
  Scenario: Gets
    When I view "/"
    Then I should see "Root"

  Scenario: Puts
    When I post to "/post":
      | key  | value |
      | name | Fred  |
    Then I should see "My name is Fred"