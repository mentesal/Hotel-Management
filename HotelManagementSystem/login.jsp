<%@ page contentType="text/html;charset=UTF-8" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Login | Hotel Management</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">

            <div class="card shadow">
                <div class="card-body">
                    <h3 class="text-center mb-4">Admin / Staff Login</h3>

                    <!-- Error Message -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/login" method="post">

                        <div class="mb-3">
                            <label>Email</label>
                            <input type="email" name="email"
                                   class="form-control"
                                   placeholder="admin@hotel.com"
                                   required>
                        </div>

                        <div class="mb-3">
                            <label>Password</label>
                            <input type="password" name="password"
                                   class="form-control"
                                   required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">
                            Login
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <a href="register.jsp">Create account</a> |
                        <a href="index.jsp">Back to Home</a>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>
