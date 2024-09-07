@regressionGoRest
Feature: This is a feature to retrieve user details via https://gorest.co.in

  Background:

    * url URL_GOREST_CO_IN
    * def pathName = 'public/v2/users'

    * def GETPublicV2Users = 'classpath:tests/get-public-users.feature@GETPublicV2Users'

  # (shared scope)
  @ignore
  @GETPublicV2Users
  Scenario: Get user details
    Given path pathName
    When method GET

  @retrievePublicUser
  Scenario: Retrieve a user details successfully

    When call read(POSTPublicV2Users)
    Then match responseStatus == 200