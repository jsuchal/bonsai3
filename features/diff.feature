Feature: Wiki
  In order to share content on wiki
  A user
  Should be able to see history of changes

  Background:
      Given that a "test" page with multiple revisions exist

  @wip
    Scenario: User wants to see the diff of two page revisions long version
      When I am logged in
      And I create "/myDiffpage" page
      And I follow "History"
      Then I should see "Changed at"
      When I check "check_all_revisions"
      And I press "Compare selected"
      Then I should not see "Changed at"
      And I should see "Difference between revision #1"
      And I should see "This is second revision"