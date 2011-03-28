Feature: Wiki layouting and many page parts
  In order to have structured pages on wiki
  A user
  Should be able to define layout and edit page parts

  Background:
    Given I am logged in

  Scenario: User creates a page with page part header and pewe layout
    When I create "/my" page with title "Root page" body "Root body!" and "PeWe Layout" layout
    And I add "navigation" page part with text "This is a header"
    Then I should see "This is a header" within "#nav"

  Scenario: User create a page part and change its content
    When I create "/my" page
    And I add "part1" page part with text "This is a header"
    Then I should see "This is a header"
    And I edit "my" page "part1" part with text "new content"
    #Then I should see "Page successfully updated."
    And I should see "new content"

  Scenario: User create a page part and change its name
    When I create "/my" page
    And I add "part1" page part with text "This is a header"
    Then I should see "This is a header"
    And I edit "my" page "part1" part name with "part2"
    #Then I should see "Page successfully updated."
    When I follow "Edit"
    Then I should see "part2"
