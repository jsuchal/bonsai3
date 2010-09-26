Feature: Wiki pages
  In order to share content on wiki
  A user
  Should be able to create and manage wiki pages

  Scenario: User visits a fresh wiki
    puts request.env
    When I go to the home page
    Then I should see "Home"