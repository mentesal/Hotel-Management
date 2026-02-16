package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class LoginServlet extends HttpServlet {

    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));

        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {

            req.setAttribute("error", "Email and Password are required!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        email = email.trim().toLowerCase();
        password = password.trim();

        try {
            String hashedPassword = hashPassword(password);

            try (Connection con = DatabaseUtil.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT email, role FROM users WHERE LOWER(email)=? AND password=?")) {

                ps.setString(1, email);
                ps.setString(2, hashedPassword);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {

                    String role = rs.getString("role");

                    HttpSession session = req.getSession(true);
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("role", role);

                    if ("ADMIN".equalsIgnoreCase(role)) {
                        resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
                    } else if ("STAFF".equalsIgnoreCase(role)) {
                        resp.sendRedirect(req.getContextPath() + "/staff/dashboard.jsp");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/index.jsp");
                    }

                } else {
                    req.setAttribute("error", "Invalid email or password!");
                    req.getRequestDispatcher("login.jsp").forward(req, resp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Login error: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
