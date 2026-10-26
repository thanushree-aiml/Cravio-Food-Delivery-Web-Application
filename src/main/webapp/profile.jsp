<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRAVIO - My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="auth-card">
                <h2 class="fw-bold mb-4">My Profile</h2>

                <% if ("true".equals(request.getParameter("success"))) { %>
                    <div class="alert alert-success">Profile updated successfully!</div>
                <% } %>

                <%
                    User user = (User) request.getAttribute("user");
                    if (user != null) {
                %>
                <form action="updateProfile" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email (Cannot be changed)</label>
                        <input type="email" class="form-control form-control-custom" value="<%= user.getEmail() %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Username</label>
                        <input type="text" name="username" class="form-control form-control-custom" value="<%= user.getUsername() %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Phone</label>
                        <input type="text" name="phone" class="form-control form-control-custom" value="<%= user.getPhone() %>" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Address</label>
                        <textarea name="address" rows="3" class="form-control form-control-custom" required><%= user.getAddress() %></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary-custom w-100 py-2">Update Profile</button>
                </form>
                <% } else { %>
                    <p>Could not load profile. Please log in again.</p>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>