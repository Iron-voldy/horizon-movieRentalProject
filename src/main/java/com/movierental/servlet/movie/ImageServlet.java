/**
 * Step 5: Create an ImageServlet to serve movie cover photos
 * File: src/main/java/com/movierental/servlet/movie/ImageServlet.java
 */
package com.movierental.servlet.movie;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;

/**
 * Servlet for serving movie cover photos
 */
@WebServlet("/image-servlet")
public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - serves the image file
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get movie ID from request
        String movieId = request.getParameter("movieId");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Movie ID is required");
            return;
        }

        // Create MovieManager with ServletContext
        MovieManager movieManager = new MovieManager(getServletContext());

        // Get the file path for the movie's cover photo
        String coverPhotoPath = movieManager.getCoverPhotoFilePath(movieId);

        // Check if the cover photo exists
        if (coverPhotoPath == null) {
            // Use a default image if the movie doesn't have a cover photo
            servePlaceholderImage(response);
            return;
        }

        File imageFile = new File(coverPhotoPath);
        if (!imageFile.exists() || !imageFile.isFile()) {
            // Use a default image if the file doesn't exist
            servePlaceholderImage(response);
            return;
        }

        // Set the content type based on file extension
        String contentType = getContentType(coverPhotoPath);
        response.setContentType(contentType);

        // Write the image data to the response
        try (FileInputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            getServletContext().log("Error serving image: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving image");
        }
    }

    /**
     * Determine the content type based on file extension
     */
    private String getContentType(String filePath) {
        String extension = filePath.substring(filePath.lastIndexOf('.')).toLowerCase();

        switch (extension) {
            case ".jpg":
            case ".jpeg":
                return "image/jpeg";
            case ".png":
                return "image/png";
            case ".gif":
                return "image/gif";
            case ".bmp":
                return "image/bmp";
            case ".webp":
                return "image/webp";
            default:
                return "application/octet-stream";
        }
    }

    /**
     * Serve a placeholder image when the movie doesn't have a cover photo
     */
    private void servePlaceholderImage(HttpServletResponse response) throws IOException {
        // Look for placeholder.jpg in WEB-INF/images directory
        String placeholderPath = getServletContext().getRealPath("/WEB-INF/images/placeholder.jpg");
        File placeholderFile = new File(placeholderPath);

        // Use placeholder if it exists
        if (placeholderFile.exists()) {
            response.setContentType("image/jpeg");

            try (FileInputStream in = new FileInputStream(placeholderFile);
                 OutputStream out = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } else {
            // Generate a simple placeholder if the file doesn't exist
            response.setContentType("image/svg+xml");
            response.getWriter().write("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"300\" viewBox=\"0 0 200 300\">"
                    + "<rect width=\"200\" height=\"300\" fill=\"#333333\"/>"
                    + "<text x=\"100\" y=\"150\" font-family=\"Arial\" font-size=\"20\" text-anchor=\"middle\" fill=\"#999999\">"
                    + "No Image</text></svg>");
        }
    }
}