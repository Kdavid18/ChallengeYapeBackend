Feature: Get booking information

  Background:
    * def getBooking = call read('get-booking-id.feature@get-booking')
    * def quantityBooking = getBooking.response.length
    * print quantityBooking
    Given url baseUrl + endpointBooking
    And header Content-Type = 'application-json'
    And header Accept = '*/*'

  Scenario: Get booking information successfully
    * def lastId = quantityBooking - 1
    * def randomId =
    """
      function(lastId) {
        var randomId = Math.floor(Math.random() * lastId);
        return randomId;
    }
    """
    * def id = randomId(lastId)
    And path id
    When method GET
    Then status 200
