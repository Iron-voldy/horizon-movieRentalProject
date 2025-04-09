package com.movierental.config;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.File;
import java.util.logging.Logger;

public class ApplicationInitializer implements ServletContextListener {
    private static final Logger LOGGER = Logger.getLogger(ApplicationInitializer.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Initialize application-wide resources
        String appName = sce.getServletContext().getInitParameter("app-name");
        String environment = sce.getServletContext().getInitParameter("environment");

        LOGGER.info("Initializing " + appName + " in " + environment + " environment");

        // Create essential directories
        createRequiredDirectories();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup resources if needed
        LOGGER.info("Application is shutting down");
    }

    private void createRequiredDirectories() {
        String[] requiredDirs = {
                "data",
                "data/movies",
                "data/users",
                "data/rentals",
                "data/reviews",
                "data/recommendations",
                "logs"
        };

        for (String dirPath : requiredDirs) {
            File dir = new File(dirPath);
            if (!dir.exists()) {
                boolean created = dir.mkdirs();
                if (created) {
                    LOGGER.info("Created directory: " + dirPath);
                } else {
                    LOGGER.warning("Failed to create directory: " + dirPath);
                }
            }
        }
    }
}