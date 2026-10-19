<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVIO - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="auth-card">
                <h2 class="text-center fw-bold mb-4">Login to CRAVIO</h2>

                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger text-center">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                <% if ("success".equals(request.getParameter("registration"))) { %>
                    <div class="alert alert-success text-center">
                        Registration successful! Please login.
                    </div>
                <% } %>

                <form action="login" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email</label>
                        <input type="email" name="email" class="form-control form-control-custom" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Password</label>
                        <input type="password" name="password" class="form-control form-control-custom" required>
                    </div>
                    <button type="submit" class="btn btn-primary-custom w-100 py-2">Login</button>
                </form>

                <div class="text-center mt-4">
                    <span class="text-muted">Don't have an account? </span>
                    <a href="register.jsp" class="fw-bold" style="color: var(--primary);">Register here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add this inside your login.jsp, just above the "Don't have an account?" text -->

<div class="text-end mb-3">
    <a href="forgotPassword" class="text-decoration-none small fw-bold" style="color: var(--primary);">Forgot Password?</a>
</div>

<!-- Add this near the top where you show error messages -->
<% if ("success".equals(request.getParameter("reset"))) { %>
    <div class="alert alert-success text-center">
        <i class="bi bi-check-circle-fill"></i> Password reset successful! Please login.
    </div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>