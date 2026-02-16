<%@ page import="java.sql.*, com.controllers.DatabaseUtil" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String roomIdStr = request.getParameter("id");
    if (roomIdStr == null) {
        response.sendRedirect("view-rooms.jsp");
        return;
    }

    int roomId = Integer.parseInt(roomIdStr);
    String roomNumber = "";
    String roomType = "";
    double price = 0;
    String status = "";

    try {
        Connection con = DatabaseUtil.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM rooms WHERE room_id=?");
        ps.setInt(1, roomId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            roomNumber = rs.getString("room_number");
            roomType = rs.getString("room_type");
            price = rs.getDouble("price");
            status = rs.getString("status");
        } else {
            response.sendRedirect("view-rooms.jsp");
            return;
        }
        rs.close();
        ps.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
    
    <title>Edit Room | Admin Dashboard</title>
</head>
<body>
    <h2>Edit Room</h2>
<form action="../editroom" method="post">

        <input type="hidden" name="room_id" value="<%= roomId %>">

        <label>Room Number:</label><br>
        <input type="text" name="room_number" value="<%= roomNumber %>" required><br><br>

        <label>Room Type:</label><br>
        <input type="text" name="room_type" value="<%= roomType %>" required><br><br>

        <label>Price:</label><br>
        <input type="number" step="0.01" name="price" value="<%= price %>" required><br><br>

        <label>Status:</label><br>
        <select name="status" required>
            <option value="AVAILABLE" <%= status.equals("AVAILABLE") ? "selected" : "" %>>AVAILABLE</option>
            <option value="BOOKED" <%= status.equals("BOOKED") ? "selected" : "" %>>BOOKED</option>
            <option value="MAINTENANCE" <%= status.equals("MAINTENANCE") ? "selected" : "" %>>MAINTENANCE</option>
        </select><br><br>

        <button type="submit">Update Room</button>
    </form>

    <a href="view-rooms.jsp">Back to View Rooms</a>
</body>
</html>
