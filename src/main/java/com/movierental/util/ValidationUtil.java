package com.movierental.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    // Email validation regex pattern
    private static final String EMAIL_REGEX =
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";

    // Username validation regex pattern
    private static final String USERNAME_REGEX = "^[a-zA-Z0-9_]{3,20}$";

    // Password validation regex pattern
    private static final String PASSWORD_REGEX = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,20}$";

    // Validate email address
    public static boolean isValidEmail(String email) {
        return email != null && Pattern.matches(EMAIL_REGEX, email);
    }

    // Validate username
    public static boolean isValidUsername(String username) {
        return username != null && Pattern.matches(USERNAME_REGEX, username);
    }

    // Validate password
    public static boolean isValidPassword(String password) {
        return password != null && Pattern.matches(PASSWORD_REGEX, password);
    }

    // Check if string is null or empty
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    // Validate integer within a range
    public static boolean isValidIntegerRange(int value, int min, int max) {
        return value >= min && value <= max;
    }

    // Trim and clean input string
    public static String cleanInput(String input) {
        return input != null ? input.trim() : "";
    }
}