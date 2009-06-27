Feature: Application Tracking
  In order to tie my tracking in with interesting application-level stats
  As an application developer
  I want to track additional facets of data from my application
  
  Scenario: Track an additional facet
    Given an empty tracking database
    When I view "/extra?track=stuff"
    Then there should be a tracking event "1":
      | key   | value |
      | extra | stuff |