package utils;

import java.util.Random;

public class commonUtils {

    public static String getRandomString(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder randomString = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < length; i++) {
            randomString.append(chars.charAt(random.nextInt(chars.length())));
        }

        return randomString.toString();
    }

    public static String getRandomEmailAddress(int length) {
        String chars = "abcdefghijklmnopqrstuvwxyz1234567890";
        StringBuilder email = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < length; i++) {
            email.append(chars.charAt(random.nextInt(chars.length())));
        }

        email.append("@karateapitest.com");

        return email.toString();
    }

    public static String getRandom(String[] array) {
        Random generator = new Random();
        int randomIndex = generator.nextInt(array.length);
        return array[randomIndex];
    }
}