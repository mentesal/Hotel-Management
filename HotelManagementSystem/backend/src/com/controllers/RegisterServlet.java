package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.security.MessageDigest;

public class RegisterServlet extends HttpServlet {

    //  Password hashing method (SHA-256)
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));

        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("full_name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        //  Basic validation
        if (fullName == null || email == null || password == null ||
            fullName.trim().isEmpty() ||
            email.trim().isEmpty() ||
            password.trim().isEmpty()) {

            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        try (Connection con = DatabaseUtil.getConnection()) {

            if (con == null) {
                throw new SQLException("Database connection failed.");
            }

            //  Check if email already exists
            String checkSql = "SELECT user_id FROM users WHERE email=?";
            try (PreparedStatement checkStmt = con.prepareStatement(checkSql)) {
                checkStmt.setString(1, email);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        req.setAttribute("error", "Email already exists.");
                        req.getRequestDispatcher("register.jsp").forward(req, resp);
                        return;
                    }
                }
            }

           String sql = "INSERT INTO users (full_name, email, password, role) VALUES (?, ?, ?, ?)";

PreparedStatement ps = con.prepareStatement(sql);
ps.setString(1, fullName);
ps.setString(2, email);
ps.setString(3, password);
ps.setString(4, "GUEST");  // FORCE GUEST

ps.executeUpdate();


            // Redirect to login page after success
            resp.sendRedirect(req.getContextPath() + "/login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
}
