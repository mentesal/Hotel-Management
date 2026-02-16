<%@ page import="java.sql.*" %>
<%@ page import="com.controllers.DatabaseUtil" %>
<%@ page session="true" %>

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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Optional Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Hotel Management</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="../guest/available-rooms.jsp">Guest View</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="../login.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Container --><div class="container mt-4">

    <div class="row mb-4">
        <div class="col">
            <h2>Welcome, <%= session.getAttribute("email") %>!</h2>
            <p class="text-muted">You are logged in as ADMIN.</p>
        </div>
    </div>

    <!-- Quick Action Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Add Room</h5>
                    <p class="card-text">Add new rooms to your hotel.</p>
                    <a href="add-room.jsp" class="btn btn-primary">Go</a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">View Rooms</h5>
                    <p class="card-text">Check and manage existing rooms.</p>
                    <a href="view-rooms.jsp" class="btn btn-primary">Go</a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Guest View</h5>
                    <p class="card-text">See available rooms from guest perspective.</p>
                    <a href="../guest/available-rooms.jsp" class="btn btn-primary">Go</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Rooms Table -->
    <div class="row">
        <div class="col">
            <h3>All Rooms</h3>
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Number</th>
                        <th>Type</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    // Fetch rooms from database
                    try (Connection con = com.controllers.DatabaseUtil.getConnection()) {
                        PreparedStatement ps = con.prepareStatement("SELECT * FROM rooms");
                        ResultSet rs = ps.executeQuery();
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
                        <td>$<%= price %></td>
                        <td><%= status %></td>
                        <td>
                            <a href="edit-room.jsp?id=<%= id %>" class="btn btn-sm btn-warning">Edit</a>
                            <a href="delete-room?id=<%= id %>" class="btn btn-sm btn-danger"
                               onclick="return confirm('Are you sure you want to delete this room?');">
                               Delete
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } catch(Exception e) {
                        out.println("<tr><td colspan='6'>Error fetching rooms</td></tr>");
                        e.printStackTrace();
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>


</body>
</html>
