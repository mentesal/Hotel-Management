package com.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html;charset=UTF-8");

        // 1 Get parameters
        String roomIdStr = req.getParameter("room_id");
        String guestName = req.getParameter("guest_name");
        String guestPhone = req.getParameter("guest_phone");
        String checkIn = req.getParameter("check_in");
        String checkOut = req.getParameter("check_out");

        // 2 Validate parameters
        if (roomIdStr == null || guestName == null || guestPhone == null ||
            checkIn == null || checkOut == null ||
            roomIdStr.isEmpty() || guestName.isEmpty() || guestPhone.isEmpty() ||
            checkIn.isEmpty() || checkOut.isEmpty()) {

            resp.getWriter().println("Error: All fields are required!");
            return;
        }

        int roomId;
        try {
            roomId = Integer.parseInt(roomIdStr);
        } catch (NumberFormatException e) {
            resp.getWriter().println("Error: Invalid Room ID!");
            return;
        }

        // 3 Connect to database
        try (Connection con = DatabaseUtil.getConnection()) {

            if (con == null) {
                resp.getWriter().println("Error: Database connection failed!");
                return;
            }

            // 4 Insert booking
            String sqlBooking = "INSERT INTO booking (room_id, guest_name, guest_phone, check_in, check_out) "
                              + "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement psBooking = con.prepareStatement(sqlBooking)) {
                psBooking.setInt(1, roomId);
                psBooking.setString(2, guestName);
                psBooking.setString(3, guestPhone);
                psBooking.setString(4, checkIn);
                psBooking.setString(5, checkOut);
                psBooking.executeUpdate();
            }

            // 5 Update room status
            String sqlUpdate = "UPDATE rooms SET status='BOOKED' WHERE room_id=?";
            try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                psUpdate.setInt(1, roomId);
                psUpdate.executeUpdate();
            }

            // 6 Redirect to available rooms
            resp.sendRedirect(req.getContextPath() + "/guest/available-rooms.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("Database Error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Unexpected Error: " + e.getMessage());
        }
    }
}
