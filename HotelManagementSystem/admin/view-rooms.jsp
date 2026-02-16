<%@ page import="java.sql.*, com.controllers.DatabaseUtil" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("../login.jsp");
        return;
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
    <title>View Rooms | Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

    <h2>All Rooms</h2>
    <a href="dashboard.jsp" class="btn btn-secondary mb-3">Back to Dashboard</a>
    <a href="add-room.jsp" class="btn btn-success mb-3">Add New Room</a>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Room Number</th>
                <th>Type</th>
                <th>Price</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try (Connection con = DatabaseUtil.getConnection()) {
                if (con == null) {
        %>
                    <tr><td colspan="6" class="text-danger">Database connection failed!</td></tr>
        <%
                } else {
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM rooms");

                    while (rs.next()) {
                        int id = rs.getInt("room_id");
                        String number = rs.getString("room_number");
                        String type = rs.getString("room_type");
                        double price = rs.getDouble("price");
                        String status = rs.getString("status");
        %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= number %></td>
                            <td><%= type %></td>
                            <td><%= price %></td>
                            <td><%= status %></td>
                            <td>
                                <a href="edit-room.jsp?id=<%= id %>" class="btn btn-primary btn-sm">Edit</a>
                                <a href="DeleteRoomServlet?id=<%= id %>" class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure you want to delete this room?');">Delete</a>
                            </td>
                        </tr>
        <%
                    }
                    rs.close();
                    stmt.close();
                }
            } catch(Exception e) {
        %>
                <tr><td colspan="6" class="text-danger">Error: <%= e.getMessage() %></td></tr>
        <%
                e.printStackTrace();
            }
        %>
        </tbody>
    </table>

</body>
</html>
