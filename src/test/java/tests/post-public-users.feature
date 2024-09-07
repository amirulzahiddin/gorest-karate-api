@regressionGoRest
Feature: This is a feature to create new user via POST /public/v2/users endpoint

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = PATH_NAME

    * def POSTPublicV2Users = 'classpath:tests/post-public-users.feature@POSTPublicV2Users'
    * def requestBody = read('classpath:properties/request-body.json')
    * def responseBody = read('classpath:properties/response-body.json')

    * def utils = Java.type('utils.commonUtils')
    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * configure headers = { 'Authorization': #(accessToken) }

    * def name = typeof name !== 'undefined' ? name : utils.getRandomString(10)
    * def email = typeof email !== 'undefined' ? email : utils.getRandomEmailAddress(10)
    * def gender = typeof gender !== 'undefined' ? gender : utils.getRandom(['male','female'])
    * def status = typeof status !== 'undefined' ? status : utils.getRandom(['active','inactive'])

  # (shared scope)
  @ignore
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

    Then match responseStatus == 422
    And match response[0].field == "<field>"
    And match response[0].message == "<message>"

    Examples:
      | name      | gender | email           | status | field  | message                               | scenario                       |
      |           | male   | email@email.com | active | name   | can't be blank                        | name is empty                  |
      | some name |        | email@email.com | active | gender | can't be blank, can be male of female | gender is empty                |
      | some name | gender | email@email.com | active | gender | can't be blank, can be male of female | gender is in invalid format    |
      | some name | male   | email           | active | email  | is invalid                            | email is in invalid format     |
      | some name | male   | email@email.com | active | email  | has already been taken                | email specified already exists |
      | some name | male   | email@email.com |        | status | can't be blank                        | status is empty                |
      | some name | male   | email@email.com | status | status | can't be blank                        | status is in invalid format    |