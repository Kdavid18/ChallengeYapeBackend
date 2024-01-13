Feature: Get data from clients for booking id

  Background:
    Given url baseUrl
    And path endpointBooking
    And header Content-Type = 'application/json'

  @get-booking
  Scenario: Get data successful without parameters
    When method GET
    Then status 200
    And match response == "#array"

  @ignore
  Scenario Outline: Get data successful with one parameter
    And param <param> = <value>
    When method GET
    Then status 200
    And match response == "#array"
    And def responseSize = response.length
    And print responseSize
    And def bookingIds = []
    And if (responseSize > 0) karate.repeat(responseSize, function(i){bookingIds.push(response[i].bookingid)})
    And print bookingIds
    And def allMatchId = true
    And karate.forEach(bookingIds, function(bookingid){ if (typeof bookingid != 'number') allMatchId = false })
    And match allMatchId == true

    Examples:
      | param     | value        |
      | firstname | 'Mary'       |
      | lastname  | 'Jones'      |
      | checkin   | '2020-12-31' |
      | checkout  | '2021-01-06' |

  @ignore
  Scenario Outline: Get data successful with multiple parameters
    And def queryParams = {}
    And queryParams.firstname = <firstname>
    And queryParams.lastname = <lastname>
    And queryParams.checkin = <checkin>
    And queryParams.checkout = <checkout>
    And params queryParams
    When method GET
    Then status 200
    And match response == "#array"
    And def responseSize = response.length
    And print responseSize
    And def bookingIds = []
    And if (responseSize > 0) karate.repeat(responseSize, function(i){bookingIds.push(response[i].bookingid)})
    And print bookingIds
    And def allMatchId = true
    And karate.forEach(bookingIds, function(bookingid){ if (typeof bookingid != 'number') allMatchId = false })
    And match allMatchId == true

    Examples:
      | firstname | lastname  | checkin      | checkout     |
      | 'Mary'    | 'Jones'   | '2020-12-31' | '2021-01-06' |
      | 'John'    | null      | '2021-01-01' | '2021-01-10' |
      | 'Alice'   | 'Smith'   | null         | '2021-02-20' |
      | 'James'   | 'Brown'   | '2021-02-20' | null         |
      | null      | 'Jackson' | '2021-12-31' | '2021-02-20' |
      | null      | null      | '2021-01-01' | '2021-01-10' |
      | 'Alice'   | 'Smith'   | null         | null         |
      | 'James'   | null      | '2021-02-20' | null         |
      | null      | 'Jackson' | null         | '2021-02-20' |
      | null      | 'Smith'   | '2021-02-20' | null         |
      | 'Jim'     | null      | null         | '2021-02-20' |


  Scenario Outline: Error getting data with empty parameters
    And def queryParams = {}
    And queryParams.firstname = <firstname>
    And queryParams.lastname = <lastname>
    And queryParams.checkin = <checkin>
    And queryParams.checkout = <checkout>
    And params queryParams
    When method GET
    Then status 500

    Examples:
      | firstname | lastname  | checkin      | checkout     |
      | 'John'    | ''        | '2021-01-01' | '2021-01-10' |
      | 'Alice'   | 'Smith'   | ''           | '2021-02-20' |
      | 'James'   | 'Brown'   | '2021-02-20' | ''           |
      | ''        | 'Jackson' | '2021-12-31' | '2021-02-20' |
      | ''        | ''        | ''           | ''           |