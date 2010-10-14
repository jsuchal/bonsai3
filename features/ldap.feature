Feature: LDAP
  In order to access wiki
  A user
  Should be able to log in using LDAP

  Scenario: Anonymous user logs in successfully
    When I login as "johno"
    Then I should see "You have successfully logged in!"
    Then I should see "johno (johno) | Log out"

  Scenario: Anonymous user logs not successfully
    When I login as "johno" using password "badpass"
    Then I should see "Login failed. Invalid credentials."
    And I should not see "Logged in as:"

  Scenario: User wants to log out.
    When I login as "johno"
    And I follow "Log out"
    Then I should see "Logout successful!"
    And show me the page
    And I should not see "Logged in as:"

  @wip
  Scenario: Anonymous user visits a fresh wiki
    When I go to the home page
    Then I should see "Permission denied."