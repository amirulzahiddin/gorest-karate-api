@regressionGoRest
Feature: This is a feature to create new user via POST /public/v2/users endpoint

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = PATH_NAME

    * def POSTPublicV2Users = 'classpath:tests/post-public-users.feature@POSTPublicV2Users'
    * def requestBody = read('classpath:properties/request-body.json')
    * def responseBody = read('classpath:properties/response-body.json')
    * def errorMessages = read('classpath:properties/error-messages.json')
    * def userEnums = read('classpath:properties/user-enums.json')

    * def utils = Java.type('utils.commonUtils')
    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * configure headers = { 'Authorization': #(accessToken) }

    * def name = typeof name !== 'undefined' ? name : utils.getRandomString(10)
    * def email = typeof email !== 'undefined' ? email : utils.getRandomEmailAddress(10)
    * def gender = typeof gender !== 'undefined' ? gender : utils.getRandom(userEnums.gender)
    * def status = typeof status !== 'undefined' ? status : utils.getRandom(userEnums.status)

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

    Given def name = <name>
    And def email = <email>
    And def gender = <gender>
    And def status = <status>

    When call read(POSTPublicV2Users)

    Then match responseStatus == 422
    And match response[0].field == <field>
    And match response[0].message == <message>

    Examples:
      | name | gender              | email             | status              | field                  | message                  | scenario                       |
      | null | userEnums.gender[0] | 'email@email.com' | userEnums.status[0] | errorMessages.field[0] | errorMessages.message[0] | name is empty                  |
      | name | null                | 'email@email.com' | userEnums.status[0] | errorMessages.field[1] | errorMessages.message[1] | gender is empty                |
      | name | gender              | 'email@email.com' | userEnums.status[0] | errorMessages.field[1] | errorMessages.message[1] | gender is in invalid format    |
      | name | userEnums.gender[0] | null              | userEnums.status[1] | errorMessages.field[2] | errorMessages.message[0] | email is empty                 |
      | name | userEnums.gender[0] | email             | userEnums.status[1] | errorMessages.field[2] | errorMessages.message[2] | email is in invalid format     |
      | name | userEnums.gender[0] | 'email@email.com' | userEnums.status[1] | errorMessages.field[2] | errorMessages.message[3] | email specified already exists |
      | name | userEnums.gender[1] | 'email@email.com' | null                | errorMessages.field[3] | errorMessages.message[0] | status is empty                |
      | name | userEnums.gender[1] | 'email@email.com' | status              | errorMessages.field[3] | errorMessages.message[0] | status is in invalid format    |