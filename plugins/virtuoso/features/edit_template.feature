Feature: edit template
  As a noosfero user
  I want to create and edit templates

  Background:
    Given I am on the homepage
    And plugin Virtuoso is enabled on environment
    And the following users
      | login     | name       |
      | joaosilva | Joao Silva |
    And I am logged in as "joaosilva"
    And the following custom queries
      | name      | query      | template    |
      | Default   | query-1    | template-1  |

  @selenium
  Scenario:
    Given I am on joaosilva's control panel
    And I follow "Manage Content"
    And I should see "New content"
    And I follow "New content"
    And I should see "Triples template" within ".article-types"
    When I follow "Triples template" within ".article-types"
    And I follow "Copy" within ".custom-query"
    Then the "SPARQL Query" field should contain "query-1"
