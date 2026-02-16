<%@ page import="java.sql.*" %>
<%@ page import="com.controllers.DatabaseUtil" %>
<%
    String roomId = request.getParameter("room_id");
    if (roomId == null) {
        response.sendRedirect("available-rooms.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Optional: Bootstrap JS (for modals, dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <title>Book Room</title>
    <style>
        body { font-family: Arial; text-align:center; margin-top:50px; }
        form { display:inline-block; text-align:left; }
        label { display:block; margin:10px 0 5px; }
        input { padding:8px; width:250px; }
        button { margin-top:20px; padding:10px 20px; background:#333; color:white; border:none; cursor:pointer; }
        button:hover { background:#555; }
    </style>
</head>
<body>

<h2>Book Room</h2>

<form action="../book-room" method="post">
    <input type="hidden" name="room_id" value="<%= roomId %>">
    <label>Your Name:</label>
    <input type="text" name="guest_name" required>
    
    <label>Phone Number:</label>
    <input type="text" name="guest_phone" required>
    
    <label>Check-in Date:</label>
    <input type="date" name="check_in" required>
    
    <label>Check-out Date:</label>
    <input type="date" name="check_out" required>
    
    <button type="submit">Confirm Booking</button>
</form>

<br><br>
<a href="book-room.jsp?room_id=<%= room_id %>">Book</a>

</body>
</html>
