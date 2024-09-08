function configuration() {
    karate.configure('logPrettyResponse', false);
    karate.configure('connectTimeout', 30 * 4000);
    karate.configure('readTimeout', 30 * 4000);

    // Retrieve the access token from environment variable or system property
    var accessToken = java.lang.System.getenv('ACCESS_TOKEN') || karate.properties['access.token'];

    // Ensure the token is available
    if (!accessToken) {
        karate.log('Access token is missing! Make sure to pass it as an environment variable or system property.');
        throw new Error('Access token is required!');
    }

    var config = {
        URL_GOREST_CO_IN: "https://gorest.co.in/public/v2",
        PATH_NAME_USERS: "/users",
        PATH_NAME_POSTS: "/posts",
        PATH_NAME_COMMENTS: "/comments",
        PATH_NAME_TODOS: "/todos",
        ACCESS_TOKEN: accessToken
    };

    return config;
}