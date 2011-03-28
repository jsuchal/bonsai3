Feature: Wiki javascript functionality

  Background:
    Given user "johno" exists
    Given user "jolan" exists
    Given user "jozef" exists

@wip
Scenario: Check if autocomplete works
    When I login as "johno"
    And I create "/my" page with title "my page"
    And I follow "Edit"
    When I fill in "page_permission_group_names" with "jo"
    And I wait for 2 seconds
    Then I should see "jolan"
    And I should see "jozef"

