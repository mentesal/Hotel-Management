package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        //  Invalidate session safely
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Prevent caching (VERY IMPORTANT)
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        //  Redirect properly using context path
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
