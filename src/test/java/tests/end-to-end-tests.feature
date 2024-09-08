@endToEndTest
@regressionGoRest
Feature: This is an end-to-end test for all the endpoints in GO REST

  Background:

    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * def headers = { 'Authorization': #(accessToken) }

  Scenario: Execute end-to-end test

    # Call POST /public/v2/users endpoint to create new employee entry
    * def id = karate.call('classpath:tests/post-public-users.feature@createNewUser').response.id

    # Call GET /public/v2/users endpoint to retrieve the created employee entry
    * karate.call('classpath:tests/get-public-users.feature@GETPublicV2Users')