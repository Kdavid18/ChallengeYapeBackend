Feature: check service health with a ping

  Scenario: Request health check with a ping successfully
    Given url baseUrl
    And path endpointPing
    When method GET
    Then status 201
    And match response == 'Created'
