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

@wip
  Scenario: User uses markdown syntax on wiki page
    When I create "/markdown" page with title "Markdown Page" body "[This link](http://example.net) has no title attribute."
    Then I should see a link to "http://example.net" with text "This link"

@wip
  Scenario: User creates a page with inherit layout and change layout
    When I create "/test" page with title "Main page" body "Main page body!" and "PeWe Layout" layout
    And I create "/test/inherited" page with title "Inherit page" body "Inherit page body!" and "Inherited (PeWe Layout)" layout
    And I go to the test page
    And I follow "Edit"
    And I should not see "Inherited (Default Layout)"
    And I select "Default Layout" from "page_layout"
    And I press "Save"
    And I go to the inherited page
    And I follow "Edit"
    And I should see "Inherited (Default Layout)"
    Then "" should be selected for "page_layout"

@wip
  Scenario: User creates a page with non inherit layout and change layout
    When I create "/test" page
    And I create "/test/inherited" page with title "Non Inherit page" body " Non Inherit page body!" and "PeWe Layout" layout
    And I go to the inherited page
    And I follow "Edit"
    Then "pewe" should be selected for "page_layout"
    And I should not see "Inherited (PeWe Layout)"

@wip
  Scenario: User change ordering of page parts
    When I create "/test" page with title "Main page" body "" 
    And I add "Erika" page part with text "Erika"
    And I add "Anna" page part with text "Arabela"
    And I should see "Body Erika Arabela"
    And I change ordering of page parts to "name"
    Then I should see "Arabela Body Erika"


@wip  
  Scenario: User create a page part and then delete, it should not be seen from now on
    When I create "/my" page
    And I add "header" page part with text "This is a header"
    Then I should see "This is a header"
    When I follow "Edit"
    And I delete "header" page part
    Then I should not see "header"
