Feature: Psycho

  Scenario: Is Available
    Given I have a layout
    When I view "/admin/metry"
    Then I should see "Visitors"