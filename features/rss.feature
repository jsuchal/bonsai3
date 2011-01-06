Feature: Wiki
  In order to share rss data
  A user
  Should be able to see rss changes

  Background:
    Given I am logged in

  Scenario: check if RSS feeds from page menu works properly
    When I create "/test" page with title "Root page"
    And I follow "RSS feed"
    Then I should see "Root page changes"

  Scenario: check if RSS feed of page changes from page menu works properly without login
    When I create "/test" page with title "Root page"
    And I follow "RSS feed"
    Then I should see "Root page changes"
    When I go to the home page
    And I logout
    And I go to the test page
    And I follow "RSS feed"
    Then I should see "Root page changes"

  Scenario: check if RSS works properly
    When I create "/test" page with title "Root page"
    And I follow "RSS feed"
    Then I should see "Root page changes"
    When I edit "/test" page with title "Some NEW title"
    And I follow "RSS feed"
    Then I should see "Some NEW title changes"

  @wip
  Scenario: check if user who has not permission can not see RSS
    Given user "johno" exists
    And user "matell" exists
    And I go to the home page
    And I logout
    And I login as "matell"
    When I create "/test" page with title "Root page"
    And I follow "RSS feed"
    Then I should see "Root page changes"
    When page "/test" is viewable by "matell"
    And I go to the home page
    And I logout
    And I login as "johno"
    And I go to the test page
    And I should not see "RSS feed"
    When I visit RSS feed of "test"
    Then I should not see "Root page changes"




  Scenario: check if RSS for subtree works properly on init and change
    When I create "/test" page with title "Root page"
    And I create "/test/nestedLeft" page with title "Left leaf"
    And I create "/test/nestedRight" page with title "Right leaf"
    When I go to the test page
    And I follow "RSS subtree feed"
    Then I should see "Subtree of Root page changes"
    And I should see "wikiuser (wikiuser) edited body of Root page"
    And I should see "wikiuser (wikiuser) edited body of Left leaf"
    And I should see "wikiuser (wikiuser) edited body of Right leaf"
    When I go to the test page
    And I edit "/test" page with title "Some NEW title"
    And I follow "RSS subtree feed"
    Then I should see "Subtree of Some NEW title changes"

  Scenario: check if RSS for subtree works properly with different users
    Given user "crutch" exists
    When I create "/test" page with title "Root page"
    And I create "/test/nestedLeft" page with title "Left leaf"
    And I create "/test/nestedRight" page with title "Right leaf"
    And page "/test/nestedRight/" is viewable by "wikiuser"
    When I go to the test page
    And I follow "RSS subtree feed"
    And I should see "wikiuser (wikiuser) edited body of Root page"
    And I should see "wikiuser (wikiuser) edited body of Left leaf"
    And I should see "wikiuser (wikiuser) edited body of Right leaf"
    Then I go to the home page
    And I logout
    And I login as "marosko"
    Then I go to the test page
    And I follow "RSS subtree feed"
    And I should see "wikiuser (wikiuser) edited body of Root page"
    And I should see "wikiuser (wikiuser) edited body of Left leaf"
    And I should not see "wikiuser (wikiuser) edited body of Right leaf"

  Scenario: check if RSS for subtree works properly for anonymous user
    When I create "/test" page with title "Root page"
    And I create "/test/nestedLeft" page with title "Left leaf"
    And I create "/test/nestedRight" page with title "Right leaf"
    And page "/test/nestedRight/" is viewable by "wikiuser"
    When I go to the test page
    And I follow "RSS subtree feed"
    And I should see "wikiuser (wikiuser) edited body of Root page"
    And I should see "wikiuser (wikiuser) edited body of Left leaf"
    And I should see "wikiuser (wikiuser) edited body of Right leaf"
    Then I go to the home page
    And I logout
    And I follow "RSS subtree feed"
    And I should see "wikiuser (wikiuser) edited body of Root page"
    And I should see "wikiuser (wikiuser) edited body of Left leaf"
    And I should not see "wikiuser (wikiuser) edited body of Right leaf"

