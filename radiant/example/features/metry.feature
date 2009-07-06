Feature: Radiant support
  In order to get metrics and run experiments on my Radiant applications
  As a Radiant administrator
  I want to have a Radiant extension that gives me Metry support
  
  Background:
    Given an empty tracking database
    And I am a new visitor
    And I have a layout
    And there is an empty Radiant cache
  
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
    Given a page at "/" containing:
      """
      <r:metry:experiment name="header" method="mod_visitor">
      Hello!
      <r:alternative name="grumpy">
      Go away!
      </r:alternative>
      <r:alternative name="dopey">
      Duh?
      </r:alternative>
      </r:metry:experiment>
      """
    When I view "/"
    Then I should see "Hello!"
    When I am a new visitor
    And there is an empty Radiant cache
    And I view "/"
    Then I should see "Go away!"
    When I am a new visitor
    And there is an empty Radiant cache
    And I view "/"
    Then I should see "Duh?"
    Then there should be a tracking event "1":
      | key | value |
      | visitor | 1 |
      | experiment.header | control |
    Then there should be a tracking event "2":
      | key | value |
      | visitor | 2 |
      | experiment.header | grumpy |
    Then there should be a tracking event "3":
      | key | value |
      | visitor | 3 |
      | experiment.header | dopey |
    Then there should be a visitor "1":
      | key | value |
      | experiment.header | control |
    Then there should be a visitor "2":
      | key | value |
      | experiment.header | grumpy |
    Then there should be a visitor "3":
      | key | value |
      | experiment.header | dopey |
      
  Scenario: Multiple access by same visitor should give same result
    Given a page at "/" containing:
      """
      <r:metry:experiment name="switch" method="rand">
      One
      <r:alternative name="two">
      Two
      </r:alternative>
      </r:metry:experiment>
      """
    When I view "/" 10 times
    Then I should see the same "switch" alternative 10 times
    When I am a new visitor
    And I view "/" 10 times
    Then I should see the same "switch" alternative 10 times
    When I am a new visitor
    And I view "/" 10 times
    Then I should see the same "switch" alternative 10 times
    When I am a new visitor
    And I view "/" 10 times
    Then I should see the same "switch" alternative 10 times
  
  Scenario: Caching shouldn't interfere with experiments
    Given a page at "/" containing:
      """
      <r:metry:experiment name="cached" method="mod_visitor">
      Sweet
      <r:alternative name="two">
      Sour
      </r:alternative>
      </r:metry:experiment>
      """
    When I view "/" 2 times
    Then there should be a tracking event "1":
      | key | value |
      | experiment.cached | control |
    Then there should be a tracking event "2":
      | key | value |
      | experiment.cached | control |
  
  Scenario: rand method should give reasonable experiment distribution
    Given a page at "/" containing:
      """
      <r:metry:experiment name="lots" method="rand">
      Control
      <r:alternative name="alt1">
      Alt1
      </r:alternative>
      <r:alternative name="alt2">
      Alt2
      </r:alternative>
      <r:alternative name="alt3">
      Alt3
      </r:alternative>
      <r:alternative name="alt4">
      Alt4
      </r:alternative>
      </r:metry:experiment>
      """
    When 100 visitors view "/"
    Then at least 10 should see alternative "control" of experiment "lots"
    Then at least 10 should see alternative "alt1" of experiment "lots"
    Then at least 10 should see alternative "alt2" of experiment "lots"
    Then at least 10 should see alternative "alt3" of experiment "lots"
    Then at least 10 should see alternative "alt4" of experiment "lots"
