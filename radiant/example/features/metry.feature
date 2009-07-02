Feature: Radiant support
  In order to get metrics and run experiments on my Radiant applications
  As a Radiant administrator
  I want to have a Radiant extension that gives me Metry support
  
  Background:
    Given an empty tracking database
    And I am a new visitor
    And I have a layout
  
  Scenario: Basic Tracking
    Given a page at "/" containing:
      """
      Hello!
      """
    When I view "/"
    Then I should see "Hello!"
    And there should be 1 tracking event
  
  Scenario: Caching shouldn't interfere with tracking
    Given a page at "/" containing:
      """
      Hello!
      """
    When I view "/"
    And I view "/"
    Then there should be 2 tracking events
  
  Scenario: Running an experiment
  
  Scenario: Caching shouldn't interfere with experiments