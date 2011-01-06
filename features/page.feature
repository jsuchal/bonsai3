Feature: Wiki pages
  In order to share content on wiki
  A user
  Should be able to create and manage wiki pages

  Scenario: User visits a fresh wiki
    When I go to the home page
    Then I should see "Home"

  Scenario: Logged user visits creates page
    Given I login as "johno"
    When I go to "the test page"
    Then I should see "Page or file you are looking for does not exist"
    And I follow "Page"
    And I fill in "Title" with "Test page"
    And I press "Create Page"
    Then I should see "Page was successfully created. You can set up additional details"
    And I go to "the test page"
    And I should see "Test page"

  Scenario: Logged user edit homepage
    Given I login as "johno"
    When I go to "the home page"
    And I follow "Edit"
    Then I should see "Title"