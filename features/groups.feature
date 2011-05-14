Feature: Wiki
In order to share content on wiki
A user
Should be able to create and manage wiki groups

  Background:
    Given I am logged in

  @wip
  Scenario: User wants to create new group
    When I create "/" page
    And I create "New group" group
    Then I should see "Group was successfully created."

  @wip
  Scenario: User wants to change name of group
    When I create "/" page
    And I create "Newgroup" group
    And I change "Newgroup" group name to "MyNewNameOfgroup"
    Then I should see "Group was successfully updated."
    And I should see "MyNewNameOfgroup"

  @wip
  Scenario: User wants to change name of group, just after he/she creates new group
    When I create "/" page
    And I create "MyNewGroup" group
    And I fill in "group_name" with "MyNewNameOfgroup"
    And I press "Update"
    Then I should see "Group was successfully updated."

  @wip
  Scenario: User wants to delete group
    When I create "/" page
    And I create "MyNewGroup" group
    And I follow "Back"
    Then I should see "Groups Management"
    Then I should see "MyNewGroup"
    When I delete "MyNewGroup" group
    Then I should not see "MyNewGroup"
    When I go to the main page
    And I follow "Groups"
    Then I should not see "MyNewGroup"

  @wip
  Scenario: User wants to add permisions within his group to another user
    Given user "crutch" exists
    When I create "/" page
    And I create "MyNewGroup" group
    And I add "crutch" editor to "MyNewGroup" group
    Then I should see "crutch"

  @wip
  Scenario: User wants to remove another user from his group
    Given user "crutch" exists
    When I create "/" page
    And I create "MyNewGroup" group
    And I add "crutch" editor to "MyNewGroup" group
    Then I should see "crutch"
    When I remove "crutch" member from "MyNewGroup" group
    Then I should not see "crutch"

  @wip
  Scenario: User was given permission to manage group. He wants to manage group, we check if he has permission
    Given user "crutch" exists
    When I create "/" page
    And I create "MyNewGroup" group
    And I add "crutch" editor to "MyNewGroup" group
    When I logout
    And I login as "crutch"
    And I follow "Groups"
    Then I should see "Groups Management"
    And I should see "Edit"
    And I should see "Destroy"
    When I follow "MyNewGroup" edit
    Then I should see "Group: MyNewGroup"

  @wip
  Scenario: User was not given permission to manage group. He wants to manage group, we check if he has permission
    Given user "crutch" exists
    When I create "/" page
    And I create "MyNewGroup" group
    And I add "crutch" viewer to "MyNewGroup" group
    When I logout
    And I login as "crutch"
    And I follow "Groups"
    Then I should see "Groups Management"
    And I should not see "Edit"
    And I should not see "Destroy"

  @wip
  Scenario: Return to main page
    When I create "/" page with title "Root title"
    And I follow "Groups"
    Then I should see "Groups Management"
    When I follow "Return to page"
    Then I should see "Root title"

  @wip
  Scenario: Return to nested page
    When I create "/" page with title "Root title"
    And I create "/nested_page/" page with title "Nested title"
    And I go to /nested_page/
    And I follow "Groups"
    Then I should see "Groups Management"
    When I follow "New group"
    And I follow "Return to page"
    Then I should see "Nested title"

  @wip
  Scenario: User creates new group, another user should see this group and should not see all user groups in Groups Management
    Given user "jozo" exists
    Given user "fero" exists
    Given user "jano" exists
    When I create "/" page with title "Root title"
    And I create "New group" group
    And I follow "Back"
    Then I should see "New group"
    And I should not see "jozo"
    And I should not see "fero"
    And I should not see "jano"
    When I logout
    And I login as "fero"
    And I follow "Groups"
    Then I should see "New group"
    And I should not see "jozo"
    And I should not see "jano"

  @wip
  Scenario: Anonymous user should not be able to visit Groups Management
    When I logout
    And I go to /groups
    Then I should see "Permission denied"

  @wip
  Scenario: user with the same name as group login
    When I create "/" page
    And I create "pewe" group
    Then I should see "Group was successfully created."
    When I logout
    And I login as "pewe"
    Then I should see "You have successfully logged in."
    Then I should see "pewe (pewe)"
    When I follow "Groups"
    Then I should not see "pewe "
    And I should see "pewe_group"

  @wip
  Scenario: user with the same name as group login (2)
    When I create "/" page
    And I create "fero" group
    And I should see "Group was successfully created."
    And I go to the main page
    And I create "fero_group" group
    Then I should see "Group was successfully created."
    When I logout
    And I login as "fero"
    Then I should see "You have successfully logged in."
    Then I should see "fero (fero)"
    When I follow "Groups"
    Then I should not see "fero "
    And I should see "fero_group"
    And I should see "fero_group2"

  @wip
  Scenario: User creates group with 2 editors, tries to delete both of them (there should stay at least one editor)
    Given user "crutch" exists
    When I create "/" page
    And I create "TestGroup" group
    And I add "crutch" editor to "TestGroup" group
    And I change "crutch" to viewer in "TestGroup" group
    And I change "testuser" to viewer in "TestGroup" group
    And I should see "Edit"
    And I logout
    And I login as "crutch"
    And I follow "Groups"
    And I should not see "Edit"