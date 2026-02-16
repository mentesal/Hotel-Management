package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/deleteroom")
public class DeleteRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/view-rooms.jsp");
            return;
        }

        try {
            int roomId = Integer.parseInt(idParam);

            try (Connection con = DatabaseUtil.getConnection();
                 PreparedStatement ps =
                         con.prepareStatement("DELETE FROM rooms WHERE room_id = ?")) {

                ps.setInt(1, roomId);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected == 0) {
                    System.out.println("No room found with ID: " + roomId);
                } else {
                    System.out.println("Room deleted successfully.");
                }
            }

        } catch (NumberFormatException e) {
            System.out.println("Invalid room ID format.");
        } catch (SQLException e) {
            System.out.println("Database error while deleting room:");
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/view-rooms.jsp");
    }
}
