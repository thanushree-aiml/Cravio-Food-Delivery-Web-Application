<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRAVIO - Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="d-flex align-items-center justify-content-center" style="min-height: 100vh; background: var(--bg-color);">

    <div class="auth-card" style="width: 100%; max-width: 450px;">
        <div class="text-center mb-4">
            <i class="bi bi-shield-lock text-primary-custom" style="font-size: 50px;"></i>
            <h3 class="fw-bold mt-3">Forgot Password?</h3>
            <p class="text-muted">Enter your registered email to reset your password.</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger text-center">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="forgotPassword" method="post">
            <div class="mb-4">
                <label class="form-label fw-semibold">Email Address</label>
                <input type="email" name="email" class="form-control form-control-custom" required>
            </div>
            <button type="submit" class="btn btn-primary-custom w-100 py-2">Verify Email</button>
        </form>

        <div class="text-center mt-4">
            <a href="login.jsp" class="text-muted text-decoration-none"><i class="bi bi-arrow-left"></i> Back to Login</a>
        </div>
    </div>

</body>
</html>