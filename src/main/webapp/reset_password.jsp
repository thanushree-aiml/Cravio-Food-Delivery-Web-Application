<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRAVIO - Reset Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="d-flex align-items-center justify-content-center" style="min-height: 100vh; background: var(--bg-color);">

    <div class="auth-card" style="width: 100%; max-width: 450px;">
        <div class="text-center mb-4">
            <i class="bi bi-key-fill text-primary-custom" style="font-size: 50px;"></i>
            <h3 class="fw-bold mt-3">Create New Password</h3>
            <p class="text-muted">Your new password must be different from previous ones.</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger text-center">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="resetPassword" method="post">
            <!-- Hidden field to carry the email -->
            <input type="hidden" name="email" value="<%= request.getAttribute("resetEmail") %>">
            
            <div class="mb-3">
                <label class="form-label fw-semibold">New Password</label>
                <input type="password" name="newPassword" class="form-control form-control-custom" required>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold">Confirm New Password</label>
                <input type="password" name="confirmPassword" class="form-control form-control-custom" required>
            </div>
            <button type="submit" class="btn btn-primary-custom w-100 py-2">Reset Password</button>
        </form>
    </div>

</body>
</html>