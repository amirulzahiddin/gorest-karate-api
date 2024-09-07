function configuration() {

  karate.configure('logPrettyResponse', false);
  karate.configure('connectTimeout', 30 * 4000);
  karate.configure('readTimeout', 30 * 4000);
  var specialCharacter = ".-_+%";

  var config = karate.read('classpath:config.json');

  return config;
}