@regressionGoRest
Feature: This feature retrieves user details via the GET /public/v2/users endpoint.
         If Authorization access token is not provided, the endpoint returns the system's predefined list of users.
         Else, it returns the list of users created by the caller.

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = PATH_NAME_USERS

    * def GETPublicV2Users = 'classpath:tests/get-public-users.feature@GETPublicV2Users'
    * def requestBody = read('classpath:properties/get-request-body.json')
    * def responseBody = read('classpath:properties/response-body.json')
    * def userEnums = read('classpath:properties/user-enums.json')

    * def utils = Java.type('utils.commonUtils')
    * def id = typeof id !== 'undefined' ? id : null
    * def page = typeof page !== 'undefined' ? page : null
    * def per_page = typeof per_page !== 'undefined' ? per_page : null

    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * def headers = typeof headers !== 'undefined' ? headers : null

  # (shared scope)
  @ignore
  @GETPublicV2Users
  Scenario: Retrieve the list of users with optional id.
    Given path pathName, id
    And configure headers = headers
    And params requestBody
    When method GET

  # Scenario 2
  @smokeGoRest
  @retrieveUserList
  Scenario: Retrieve the predefined list of users and verify the first entry's status is only either 'active' or 'inactive'.

    When call read(GETPublicV2Users)

    Then match responseStatus == 200
    And match each response[*] == responseBody
    And assert response[0].status == 'active' || response[0].status == 'inactive'

  @retrievePredefinedAndCustomUsersList
  Scenario: Verify the behavior of the authorization access token, where
            the system retrieves a predefined list of users if the token is not provided,
            and retrieves the caller's created list of users when the token is supplied.

    # Call the endpoint without Authorization access token header
    When call read(GETPublicV2Users)

    # Verify the response contains users' emails with "example" domain extension prefix
    # which represents the system's list of users
    Then match responseStatus == 200
    And match response..email contains '#? _.includes("example")'

    # Call the endpoint again with Authorization access token header
    Given def headers = { 'Authorization': #(accessToken) }

    When call read(GETPublicV2Users)

    # Verify the response contains users' emails with "karateapitest" domain extension prefix
    # which represents the caller's list of users
    Then match responseStatus == 200
    And match response..email contains '#? _.includes("karateapitest")'

  @retrieveUserDetailsInvalidInput
  Scenario Outline: Retrieve user details with invalid input where <scenario>.

    Given def headers = <headers>
    And def id = <id>

    When call read(GETPublicV2Users)

    Then match responseStatus == 404
    And match response.message == 'Resource not found'

    Examples:
      | headers                             | id      | scenario                                                                               |
      | { 'Authorization': #(accessToken) } | id      | id is in invalid format                                                                |
      | { 'Authorization': #(accessToken) } | 1       | id does not exist                                                                      |
      | null                                | 7392996 | access token is not specified and unable to retrieve other than the system's user list |