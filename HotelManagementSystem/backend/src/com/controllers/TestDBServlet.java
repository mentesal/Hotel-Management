package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class TestDBServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html; charset=UTF-8");

        Connection con = DatabaseUtil.getConnection();

        if (con != null) {
            resp.getWriter().println("<h2>Database connected successfully ✅</h2>");
        } else {
            resp.getWriter().println("<h2>Database connection FAILED</h2>");

        }
    }
}
