Feature: Wiki
  In order to share content on wiki
  A user
  Should be able to see history of changes

  Background:
    Given I am logged in

    @wip
    Scenario: User wants to see the diff of two page revisions long version
      When I create "/myDiffpage" page
      And I add "first part" page part with text "text 1"
      And I follow "History"
      And I compare first two revisions
      Then I should see "text 1" within ".addition"