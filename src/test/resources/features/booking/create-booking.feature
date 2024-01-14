Feature: Create new booking

  Background:
    Given url baseUrl
    And path endpointBooking
    And header Content-Type = 'application/json'
    And header Accept = '*/*'


  Scenario Outline: Create new booking successfully
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

    * def responseBody =
    """
      {
        "bookingid": '#number',
        "booking": {
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
      }
    """
    And request payload
    When method POST
    Then status 200
    And match response == responseBody

    Examples:
      | firstname | lastname     | totalprice | depositpaid | checkin      | checkout     | additionalneeds |
      | 'David'   | 'Enriquez'   | 200        | true        | '2023-12-28' | '2024-01-06' | 'Lunch'         |
      | 'David'   | 'De la cruz' | 112.58     | false       | '2024-12-28' | '2024-01-06' | 'Parking'       |

  Scenario Outline: Validate input fields
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
    And request payload
    When method POST
    Then status 200
    And assert typeof <firstname> == 'string'
    And assert typeof <lastname> == 'string'
    And assert typeof <totalprice> == 'number'
    And assert typeof <depositpaid> == 'boolean'
    And karate.match(<checkin>, '#regex \\d{4}-\\d{2}-\\d{2}')
    And karate.match(<checkout>, '#regex \\d{4}-\\d{2}-\\d{2}')
    And assert <checkin> < <checkout>
    And assert typeof <additionalneeds> == 'string'

    Examples:
      | firstname | lastname     | totalprice | depositpaid | checkin      | checkout     | additionalneeds |
      | 'David'   | 'Enriquez'   | 200        | true        | '2023-12-28' | "2024-01-06" | 'Lunch'         |
      | 'David'   | 'De la cruz' | 112.58     | false       | '2024-12-28' | "2024-01-06" | 'Parking'       |


  Scenario Outline: Error creating new booking no fields required
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
    And request payload
    When method POST
    Then status 500
    And match response == 'Internal Server Error'

    Examples:
      | firstname | lastname   | totalprice | depositpaid | checkin      | checkout     | additionalneeds |
      | null      | 'Enriquez' | 200        | true        | '2023-12-28' | '2024-01-06' | 'Lunch'         |
      | 'David'   | null       | 1500       | true        | '2023-12-28' | '2024-01-06' | 'Diner'         |
      | 'David'   | 'Enriquez' | null       | true        | '2023-12-28' | '2024-01-06' | 'Sauna'         |
      | 'David'   | 'Enriquez' | 800        | null        | '2023-12-28' | '2024-01-06' | 'Parking'       |
      | 'David'   | 'Enriquez' | 315        | true        | null         | '2024-01-06' | 'Pool'          |
      | 'David'   | 'Enriquez' | 125.5      | true        | '2023-12-28' | null         | 'Breakfast'     |
