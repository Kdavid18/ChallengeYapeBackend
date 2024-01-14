Feature: Partial update booking

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

  Scenario Outline: Partially update booking information successfully
    * def lastId = responseSize - 1
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
    * def responseBody = read('classpath:resources/data/response/response-booking.json')
    * def payload =
    """
      {
        "firstname" : <firstname>,
        "lastname" : <lastname>,
        "totalprice" : <totalprice>,
        "depositpaid" : <depositpaid>,
        "bookingdates" : {
          "checkin" : <checkin>,
          "checkout" : <checkout>
        }
      }
    """
    And path id
    And header Authorization = authToken
    And request payload
    When method PATCH
    Then status 200
    And match response == responseBody
    And eval if(<firstname> != null) response.firstname = <firstname>
    And eval if(<lastname> != null) response.lastname = <lastname>
    And eval if(<totalprice> != null) response.totalprice = <totalprice>
    And eval if(<depositpaid> != null) response.depositpaid = <depositpaid>
    And eval if(<checkin> != null) response.checkin = <checkin>
    And eval if(<checkout> != null) response.checkout = <checkout>
    And eval if(<additionalneeds> != null) response.additionalneeds = <additionalneeds>

    Examples:
      | firstname | lastname   | totalprice | depositpaid | checkin      | checkout     | additionalneeds |
      | null      | 'Enriquez' | 200        | true        | '2023-12-28' | '2024-01-06' | 'Lunch'         |
      | 'David'   | null       | 1500       | true        | '2023-12-28' | '2024-01-06' | 'Diner'         |
      | 'David'   | 'Enriquez' | null       | true        | '2023-12-28' | '2024-01-06' | 'Sauna'         |
      | 'David'   | 'Enriquez' | 800        | null        | '2023-12-28' | '2024-01-06' | 'Parking'       |
      | 'David'   | 'Enriquez' | 315        | true        | null         | '2024-01-06' | 'Pool'          |
      | 'David'   | 'Enriquez' | 125.5      | true        | '2023-12-28' | null         | 'Breakfast'     |


  Scenario: Partially update booking information with invalid parameters
    * def lastId = responseSize - 1
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
    * def responseBody = read('classpath:resources/data/response/response-booking.json')
    * def payload =
    """
      {
        "secondname" : 'David',
        "nickname" : 'Enriquez',
        "amount" : '200',
        "check" : 'true',
      }
    """
    And path id
    And header Authorization = authToken
    And request payload
    When method PATCH
    Then status 400
    And match response == 'Bad request'


  Scenario: Partially update booking information with a non-existing ID
    * def newId = read('classpath:resources/commons-functions/random-non-existing-id.js')
    * def nonExistingId = newId(bookingIds)
    * def payload =
    """
      {
        "firstname" : 'David',
        "lastname" : 'Enriquez',
        "totalprice" : '200',
        "depositpaid" : 'true',
      }
    """
    And path nonExistingId
    And header Authorization = authToken
    And request payload
    When method PATCH
    Then status 405
    And match response == 'Method Not Allowed'

  Scenario: Partially update booking information with invalid authentication token
    * def lastId = responseSize - 1
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
    * def payload =
    """
      {
        "firstname" : 'David',
        "lastname" : 'Enriquez',
        "totalprice" : '200',
        "depositpaid" : 'true',
      }
    """
    And path id
    And header Authorization = 'Basic 123'
    And request payload
    When method PATCH
    Then status 403
    And match response == 'Forbidden'



