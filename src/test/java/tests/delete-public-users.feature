@regressionGoRest
Feature: This feature deletes a user entry via the DELETE /public/v2/users endpoint.

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = PATH_NAME_USERS

    * def createNewUser = 'classpath:tests/post-public-users.feature@createNewUser'
    * def DELETEPublicV2Users = 'classpath:tests/delete-public-users.feature@DELETEPublicV2Users'

    * def utils = Java.type('utils.commonUtils')
    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * def headers = typeof headers !== 'undefined' ? headers : null

    * def id = typeof id !== 'undefined' ? id : null

  # (shared scope)
  @ignore
  @DELETEPublicV2Users
  Scenario: Delete user entry based on the user id.
    Given path pathName, id
    And configure headers = headers
    When method DELETE

  @smokeGoRest
  @deleteUserEntry
  Scenario: Delete user entry successfully.

    Given def headers = { 'Authorization': #(accessToken) }
    And def id = karate.call(createNewUser).response.id

    When call read(DELETEPublicV2Users)

    Then match responseStatus == 204