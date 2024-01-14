Feature: Get authentication token

  Background:
    Given url baseUrl + endpointAuth
    And header Content-Type = 'application/json'


  Scenario: Create token successful
    * def payload =
    """
    {
      "username" : '#(username)',
      "password" : '#(password)'
    }
    """
    And request payload
    When method POST
    Then status 200
    And match response.token == "#string"

  @auth
  Scenario Outline: Create token with invalid credentials
    * def payload =
    """
    {
      "username": <username>,
      "password": <password>
    }
    """

    * def responseBody =
    """
    {
      "reason": "Bad credentials"
    }
    """
    And request payload
    When method POST
    Then status 200
    And match response == responseBody

    Examples:
      | username | password      |
      | "agent"  | "password123" |
      | "admin"  | "123password" |

