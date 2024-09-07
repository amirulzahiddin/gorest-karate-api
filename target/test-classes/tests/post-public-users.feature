@regressionGoRest
Feature: This is a feature to execute endpoints in https://gorest.co.in

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = 'public/v2/users'

    * def utils = Java.type('utils.commonUtils');

    * def POSTPublicV2Users = 'classpath:tests/post-public-users.feature@POSTPublicV2Users'
    * def requestBody = read('classpath:properties/request-body.json')
    * def responseBody = read('classpath:properties/response-body.json')

    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * configure headers = { 'Authorization': #(accessToken) }

    * def name = typeof name !== 'undefined' ? name : utils.getRandomString(10)
    * def email = typeof email !== 'undefined' ? email : utils.getRandomEmailAddress(10)
    * def gender = typeof gender !== 'undefined' ? gender : utils.getRandom(['male','female'])
    * def status = typeof status !== 'undefined' ? status : utils.getRandom(['active','inactive'])

  # (shared scope)
  @POSTPublicV2Users
  Scenario: Create a new user
    Given path pathName
    And request requestBody
    When method POST

  @smokeGoRest
  @createPublicUser
  Scenario: Create a new user with complete details successfully

    When call read(POSTPublicV2Users)

    Then match responseStatus == 201
    And match response == responseBody
    And match response.name == name
    And match response.email == email
    And match response.gender == gender
    And match response.status == status

  @createPublicUserInvalidInput
  Scenario Outline: Create a new user with invalid input where <scenario>

    Given def name = '<name>'
    And def email = '<email>'
    And def gender = '<gender>'
    And def status = '<status>'

    When call read(POSTPublicV2Users)

    Then match responseStatus == <responseStatus>
    And match response.field == '<field>'
    And match response.message == '<message>'

    Examples:
      | name      | email           | gender | status | responseStatus | field | message                |
      | some name | email           | male   | active | 422            | email | is invalid             |
      | some name | email@email.com | male   | active | 422            | email | has already been taken |