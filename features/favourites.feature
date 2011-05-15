Feature: Wiki favourites
  In order to watch pages or files
  A user
  Should be able to (un)subscribe

  Background:
    Given I am logged in

  Scenario: User visits empty dashboard
    When I create "/watched" page with title "my page"
    And I follow "Dashboard"
    Then I should not see "my page"

  Scenario: User adds and remove page from/to favorites
    When I create "/watched" page with title "my watched page"
    And I follow "favorite"
    And I follow "Dashboard"
    Then I should see "my watched page"
    When I go to the watched page
    And I follow "favorite"
    And I follow "Dashboard"
    Then I should not see "my watched page"

  Scenario: User adds and multiple pages to favorites
    When I create "/watched" page with title "my watched page"
    And I follow "favorite"
    And I create "/watched/nested" page with title "my nested watched page"
    And I follow "favorite"
    And I follow "Dashboard"
    Then I should see "my watched page"
    And I should see "my nested watched page"

  Scenario: User visit dashboard and click on page link
    When I create "/watched" page with title "my watched page"
    And I follow "favorite"
    And I follow "Dashboard"
    When I follow "my watched page"
    Then I should see "my watched page"
    And I should see "my watched page"  
    And I should see "Some content."
