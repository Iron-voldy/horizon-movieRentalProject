package com.movierental.config;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.movierental.model.user.UserManager;

@WebListener
public class ContextInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        System.out.println("Context initialized: " + context.getContextPath());

        // Create data directories if they don't exist
        String webInfDataPath = "/WEB-INF/data";
        String realPath = context.getRealPath(webInfDataPath);

        if (realPath != null) {
            java.io.File dataDir = new java.io.File(realPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup resources if needed
    }
}