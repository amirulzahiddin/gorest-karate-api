@regressionGoRest
Feature: This is a feature to retrieve user details via GET /public/v2/users endpoint

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = PATH_NAME

    * def GETPublicV2Users = 'classpath:tests/get-public-users.feature@GETPublicV2Users'

  # (shared scope)
  @ignore
  @GETPublicV2Users
  Scenario: Get user details
    Given path pathName
    When method GET

  # Scenario 2
  @smokeGoRest
  @retrievePublicUser
  Scenario: Retrieve a user details and verify the status for the first entry is only either 'active' or 'inactive'

    When call read(GETPublicV2Users)
    Then match responseStatus == 200
    And match response[0].status == 'active' || response[0].status == 'inactive'