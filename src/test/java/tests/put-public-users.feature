@regressionGoRest
Feature: This feature updates user details via the PUT /public/v2/users endpoint.

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = PATH_NAME_USERS

    * def PUTPublicV2Users = 'classpath:tests/put-public-users.feature@PUTPublicV2Users'
    * def requestBody = read('classpath:properties/put-request-body.json')
    * def responseBody = read('classpath:properties/response-body.json')
    * def userEnums = read('classpath:properties/user-enums.json')

    * def utils = Java.type('utils.commonUtils')
    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * def headers = typeof headers !== 'undefined' ? headers : null

    * def id = typeof id !== 'undefined' ? id : 7393345
    * def name = typeof name !== 'undefined' ? name : utils.getRandomString(10)
    * def email = typeof email !== 'undefined' ? email : utils.getRandomEmailAddress(10)
    * def status = typeof status !== 'undefined' ? status : utils.getRandom(userEnums.status)

  # (shared scope)
  @ignore
  @PUTPublicV2Users
  Scenario: Update user details based on the user id.
    Given path pathName, id
    And configure headers = headers
    And request requestBody
    When method PUT

  @smokeGoRest
  @updateUserDetails
  Scenario: Update user details successfully.

    Given def headers = { 'Authorization': #(accessToken) }

    When call read(PUTPublicV2Users)

    Then match responseStatus == 200
    And match response == responseBody
    And match response.name == name
    And match response.email == email
    And match response.status == status