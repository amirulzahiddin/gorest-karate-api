function configuration() {

  karate.configure('logPrettyResponse', false);
  karate.configure('connectTimeout', 30 * 4000);
  karate.configure('readTimeout', 30 * 4000);
  var specialCharacter = ".-_+%";

  var config = karate.read('classpath:config.json');

  function getUrls(urlsConfig) {
    var envVars = java.lang.System.getenv();

    for (var entry of envVars.entrySet()) {

      var envKey = entry.getKey();
      var envValue = entry.getValue();

      if (envKey.startsWith('KARATE_URL')) {
        var actualKey = envKey.replace('KARATE_', '');

        if (urlsConfig.hasOwnProperty(actualKey)) {
          urlsConfig[actualKey] = envValue;
        } else {
          karate.abort('Environment variable "' + envKey + '" found but does not exist in urls config json.');
        }
      }
    }

    return urlsConfig;
  }

  var urls = getUrls(config.URLS);

  return {
    ...config,
    ...urls,
  };
}