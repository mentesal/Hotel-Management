<div class="container mt-5" style="max-width:600px;">
    <div class="card shadow">
        <div class="card-body">

            <h3 class="mb-4 text-center">Add New Room</h3>

            <!-- Error Message -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <%
                }
            %>

            <!-- Success Message -->
            <%
                String success = (String) request.getAttribute("success");
                if (success != null) {
            %>
                <div class="alert alert-success"><%= success %></div>
            <%
                }
            %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

            <form action="<%= request.getContextPath() %>/addroom" method="post">

                <div class="mb-3">
                    <label class="form-label">Room Number</label>
                    <input type="text" class="form-control" name="room_number" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Room Type</label>
                    <input type="text" class="form-control" name="room_type" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Price ($)</label>
                    <input type="number" class="form-control" name="price" step="0.01" min="1" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select class="form-select" name="status">
                        <option value="AVAILABLE">Available</option>
                        <option value="BOOKED">Booked</option>
                        <option value="MAINTENANCE">Maintenance</option>
                    </select>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="dashboard.jsp" class="btn btn-secondary">Back</a>
                    <button type="submit" class="btn btn-success">Add Room</button>
                </div>

            </form>

        </div>
    </div>
</div>
