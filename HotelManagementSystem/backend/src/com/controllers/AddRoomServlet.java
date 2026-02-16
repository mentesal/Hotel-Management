package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class AddRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        //  Check ADMIN session
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Get parameters
        String roomNumber = req.getParameter("room_number");
        String roomType   = req.getParameter("room_type");
        String priceStr   = req.getParameter("price");
        String status     = req.getParameter("status");

        try {

            //  Validation
            if (roomNumber == null || roomType == null || priceStr == null || status == null ||
                roomNumber.trim().isEmpty() ||
                roomType.trim().isEmpty() ||
                priceStr.trim().isEmpty()) {

                req.setAttribute("error", "All fields are required!");
                req.getRequestDispatcher("/admin/add-room.jsp").forward(req, resp);
                return;
            }

            double price = Double.parseDouble(priceStr);

            if (price <= 0) {
                req.setAttribute("error", "Price must be greater than 0!");
                req.getRequestDispatcher("/admin/add-room.jsp").forward(req, resp);
                return;
            }

            // Insert into DB (Auto close resources)
            try (Connection con = DatabaseUtil.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO rooms (room_number, room_type, price, status) VALUES (?, ?, ?, ?)")) {

                ps.setString(1, roomNumber.trim());
                ps.setString(2, roomType.trim());
                ps.setDouble(3, price);
                ps.setString(4, status);

                ps.executeUpdate();
            }

            req.setAttribute("success", "Room added successfully ");
            req.getRequestDispatcher("/admin/add-room.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Price must be a valid number!");
            req.getRequestDispatcher("/admin/add-room.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Room number already exists or database error!");
            req.getRequestDispatcher("/admin/add-room.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendRedirect(req.getContextPath() + "/admin/add-room.jsp");
    }
}
