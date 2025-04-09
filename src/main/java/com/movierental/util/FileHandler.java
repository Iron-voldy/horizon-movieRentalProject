package com.movierental.util;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for file operations
 */
public class FileHandler {

    /**
     * Checks if a file exists
     */
    public static boolean fileExists(String filePath) {
        return new File(filePath).exists();
    }

    /**
     * Ensures a file exists, creating it if necessary
     */
    public static void ensureFileExists(String filePath) throws IOException {
        File file = new File(filePath);

        // Create parent directories if needed
        if (!file.getParentFile().exists()) {
            boolean created = file.getParentFile().mkdirs();
            System.out.println("Created directory: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
        }

        // Create the file if it doesn't exist
        if (!file.exists()) {
            boolean created = file.createNewFile();
            System.out.println("Created file: " + filePath + " - Success: " + created);
        }
    }

    /**
     * Generic method to write content to a file
     */
    public static void writeToFile(String filePath, String content, boolean append) throws IOException {
        // Ensure the file exists
        ensureFileExists(filePath);

        // Write to the file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, append))) {
            writer.write(content);
        }
    }

    /**
     * Append a line to a file
     */
    public static void appendLine(String filePath, String line) throws IOException {
        writeToFile(filePath, line + System.lineSeparator(), true);
    }

    /**
     * Generic method to read lines from a file
     */
    public static List<String> readLines(String filePath) throws IOException {
        List<String> lines = new ArrayList<>();

        if (!fileExists(filePath)) {
            return lines;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }

        return lines;
    }

    /**
     * Method to create a directory if it doesn't exist
     */
    public static boolean createDirectoryIfNotExists(String directoryPath) {
        File directory = new File(directoryPath);
        if (!directory.exists()) {
            return directory.mkdirs();
        }
        return true;
    }

    /**
     * Method to delete a file
     */
    public static boolean deleteFile(String filePath) {
        File file = new File(filePath);
        return file.exists() && file.delete();
    }

    /**
     * Method to read all content from a file as a single string
     */
    public static String readFileAsString(String filePath) throws IOException {
        if (!fileExists(filePath)) {
            return "";
        }

        return new String(Files.readAllBytes(Paths.get(filePath)));
    }
}