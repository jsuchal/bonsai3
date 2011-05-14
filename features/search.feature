Feature: Wiki fulltext search

  Background:
    Given I am logged in

  Scenario: User search for some non existing data
    When I create "/test" page with title "korenova stranka" body "koren content"
    And I go to the test page
    Then I should see "korenova stranka"
    When indexes are updated
    And I search for "soren"
    Then I should see "Search results"
    Then I should not see "korenova stranka"

  @wip
  Scenario: User search for some existing data
    When I create "/test" page with title "korenova stranka"
    And I go to the test page
    Then I should see "korenova stranka"
    When indexes are updated
    And I search for "koren"
    Then I should see "Search results"
    Then I should see "korenova"
    And I follow "korenova stranka"
    And I should see "koren content"
