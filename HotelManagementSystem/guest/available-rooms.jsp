<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="com.controllers.DatabaseUtil" %>
<%
    // Optional: track guest login, can remove if not needed
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
    <!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Optional: Bootstrap JS (for modals, dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <title>Available Rooms</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin: 20px auto; }
        th, td { border: 1px solid #333; padding: 8px; text-align: center; }
        th { background-color: #074fad; color: white; }
        button { padding: 5px 10px; background-color: #074fad; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #ffcc00; color: #111; }
    </style>
</head>
<body>
    <h1 style="text-align:center;">Available Rooms</h1>

    <table>
        <tr>
            <th>Room Number</th>
            <th>Type</th>
            <th>Price</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

<%
    Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;  // declare rs here

try {
    con = DatabaseUtil.getConnection();
    if(con == null) {
%>
<tr><td colspan="5">Database connection failed!</td></tr>
<%
    } else {
        String sql = "SELECT * FROM rooms WHERE status='AVAILABLE'";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();  // initialize rs

        while(rs.next()) {   // now rs is valid
            int roomId = rs.getInt("room_id");
%>
<tr>
    <td><%= rs.getString("room_number") %></td>
    <td><%= rs.getString("room_type") %></td>
    <td>$<%= rs.getDouble("price") %></td>
    <td><%= rs.getString("status") %></td>
    <td>
        <form action="<%= request.getContextPath() %>/book-room" method="post">
            <input type="hidden" name="room_id" value="<%= roomId %>">
            Guest Name: <input type="text" name="guest_name" required>
            Guest Phone: <input type="text" name="guest_phone" required>
            Check-in: <input type="date" name="check_in" required>
            Check-out: <input type="date" name="check_out" required>
            <button type="submit">Book</button>
        </form>
    </td>
</tr>
<%
        } // end while
    } // end else
} catch(Exception e) {
%>
<tr><td colspan="5">Error: <%= e.getMessage() %></td></tr>
<%
    e.printStackTrace();
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>

    </table>

    <p style="text-align:center;"><a href="../login.jsp">Back to Login</a></p>
</body>
</html>
