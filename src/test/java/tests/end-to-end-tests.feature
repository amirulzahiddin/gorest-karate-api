@endToEndTest
@regressionGoRest
Feature: This is an end-to-end test for the complete user journey in GO REST API.

  Scenario: As a QA Engineer, I would like to perform an end-to-end testing for all user-related endpoints,
            so that I'm able to create a complete user journey and simulate real world behaviour.

    # Authorize endpoints with access token
    * def accessToken = 'Bearer ' + ACCESS_TOKEN
    * def headers = { 'Authorization': #(accessToken) }

    # Call POST /public/v2/users endpoint to create a new employee entry
    * def id = karate.call('classpath:tests/post-public-users.feature@createNewUser').response.id

    # Call GET /public/v2/users endpoint to retrieve the created employee entry
    * call read('classpath:tests/get-public-users.feature@GETPublicV2Users')
    * match responseStatus == 200

    # Call PUT /public/v2/users endpoint to update the employee details
    * call read('classpath:tests/put-public-users.feature@PUTPublicV2Users')
    * match responseStatus == 200

    # Call DELETE /public/v2/users endpoint to delete the employee entry
    * call read('classpath:tests/delete-public-users.feature@DELETEPublicV2Users')
    * match responseStatus == 204