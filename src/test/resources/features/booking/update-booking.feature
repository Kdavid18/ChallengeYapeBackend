Feature: Update booking exist

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


  Scenario Outline: Update booking information successfully
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
        },
        "additionalneeds" : <additionalneeds>
      }
    """
    And path id
    And header Authorization = authToken
    And request payload
    When method PUT
    Then status 200
    And match response == responseBody
    And match response == payload

    Examples:
      | firstname | lastname     | totalprice | depositpaid | checkin      | checkout     | additionalneeds |
      | 'David'   | 'Enriquez'   | 200        | true        | '2023-12-28' | '2024-01-06' | 'Lunch'         |
      | 'David'   | 'De la cruz' | 112.58     | false       | '2024-12-28' | '2024-01-06' | 'Parking'       |

  Scenario: Update booking information with a non-existing ID
    * def newId = read('classpath:resources/commons-functions/random-non-existing-id.js')
    * def nonExistingId = newId(bookingIds)
    * def payload = read('classpath:resources/data/request/user-data.json')
    And path nonExistingId
    And header Authorization = authToken
    And request payload
    When method PUT
    Then status 405
    And match response == 'Method Not Allowed'

  Scenario Outline: Update booking information with invalid authentication token
    * def lastId = responseSize - 1
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
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
        },
        "additionalneeds" : <additionalneeds>
      }
    """
    And path id
    And header Authorization = 'Basic 123'
    And request payload
    When method PUT
    Then status 403
    And match response == 'Forbidden'

    Examples:
      | firstname | lastname     | totalprice | depositpaid | checkin      | checkout     | additionalneeds |
      | 'David'   | 'Enriquez'   | 200        | true        | '2023-12-28' | '2024-01-06' | 'Lunch'         |
      | 'David'   | 'De la cruz' | 112.58     | false       | '2024-12-28' | '2024-01-06' | 'Parking'       |

  Scenario Outline: Update booking information without fields required
    * def lastId = responseSize - 1
    * def randomId = read('classpath:resources/commons-functions/random-id.js')
    * def id = bookingIds[randomId(lastId)]
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
        },
        "additionalneeds" : <additionalneeds>
      }
    """
    And path id
    And header Authorization = authToken
    And request payload
    When method PUT
    Then status 400
    And match response == 'Bad Request'

    Examples:
      | firstname | lastname   | totalprice | depositpaid | checkin      | checkout     | additionalneeds |
      | null      | 'Enriquez' | 200        | true        | '2023-12-28' | '2024-01-06' | 'Lunch'         |
      | 'David'   | null       | 1500       | true        | '2023-12-28' | '2024-01-06' | 'Diner'         |
      | 'David'   | 'Enriquez' | null       | true        | '2023-12-28' | '2024-01-06' | 'Sauna'         |
      | 'David'   | 'Enriquez' | 800        | null        | '2023-12-28' | '2024-01-06' | 'Parking'       |
      | 'David'   | 'Enriquez' | 315        | true        | null         | '2024-01-06' | 'Pool'          |
      | 'David'   | 'Enriquez' | 125.5      | true        | '2023-12-28' | null         | 'Breakfast'     |

