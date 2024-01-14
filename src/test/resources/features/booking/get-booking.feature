Feature: Get booking information

  Background:
    * def getBooking = call read('get-booking-id.feature@get-booking')
    * def responseSize = getBooking.response.length
    * def bookingIds = []
    * if (responseSize > 0) karate.repeat(responseSize, function(i){bookingIds.push(getBooking.response[i].bookingid)})
    * print bookingIds
    Given url baseUrl + endpointBooking
    And header Accept = '*/*'


  Scenario: Get booking information successfully
    * def lastId = responseSize - 1
    * def responseBody = read('classpath:resources/data/response/response-booking.json')
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
    And path id
    When method GET
    Then status 200
    And match response == responseBody


  Scenario: Error getting booking information with a non-existing ID
    * def newId = read('classpath:resources/commons-functions/random-non-existing-id.js')
    * def nonExistingId = newId(bookingIds)
    And path nonExistingId
    When method GET
    Then status 404
    And match response == 'Not Found'
