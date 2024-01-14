Feature: Delete booking

  Background:
    * def getBooking = call read('get-booking-id.feature@get-booking')
    * def responseSize = getBooking.response.length
    * def bookingIds = []
    * if (responseSize > 0) karate.repeat(responseSize, function(i){bookingIds.push(getBooking.response[i].bookingid)})
    * print bookingIds
    Given url baseUrl
    And path endpointBooking
    And header Content-Type = 'application/json'
    And header Accept = '*/*'

  Scenario: Delete existing booking successfully
    * def lastId = responseSize - 1
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
    And path id
    And header Authorization = authToken
    When method DELETE
    Then status 201
    And match response == 'Created'


  Scenario: Delete booking with a non-existing ID
    * def newId = read('classpath:resources/commons-functions/random-non-existing-id.js')
    * def nonExistingId = newId(bookingIds)
    And path nonExistingId
    And header Authorization = authToken
    When method DELETE
    Then status 405
    And match response == 'Method Not Allowed'


  Scenario: Delete booking with invalid authentication token
    * def lastId = responseSize - 1
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
    And path id
    And header Authorization = 'Basic 123'
    When method DELETE
    Then status 403
    And match response == 'Forbidden'
