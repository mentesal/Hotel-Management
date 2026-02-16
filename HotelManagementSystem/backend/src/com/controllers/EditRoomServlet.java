package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/editroom")
public class EditRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int roomId = Integer.parseInt(req.getParameter("room_id"));
            String roomNumber = req.getParameter("room_number");
            String roomType = req.getParameter("room_type");
            String priceStr = req.getParameter("price");
            String status = req.getParameter("status");

            if (roomNumber == null || roomType == null || priceStr == null || status == null ||
                roomNumber.trim().isEmpty() ||
                roomType.trim().isEmpty() ||
                priceStr.trim().isEmpty()) {

                resp.sendRedirect(req.getContextPath() + "/admin/view-rooms.jsp");
                return;
            }

            double price = Double.parseDouble(priceStr);

            try (Connection con = DatabaseUtil.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                         "UPDATE rooms SET room_number=?, room_type=?, price=?, status=? WHERE room_id=?")) {

                ps.setString(1, roomNumber.trim());
                ps.setString(2, roomType.trim());
                ps.setDouble(3, price);
                ps.setString(4, status);
                ps.setInt(5, roomId);

                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/view-rooms.jsp");
    }
}
