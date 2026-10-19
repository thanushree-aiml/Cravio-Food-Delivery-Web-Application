<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVIO - Order Success!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6 text-center">
            <div class="auth-card">
                <i class="bi bi-check-circle-fill text-success" style="font-size: 90px;"></i>
                <h1 class="fw-bold mt-3 mb-2">Order Placed!</h1>
                <p class="text-muted fs-5 mb-4">Thank you for ordering with CRAVIO. Your food is being prepared.</p>
                
                <%
                    Object orderId = request.getAttribute("orderId");
                    if (orderId == null) { orderId = session.getAttribute("lastOrderId"); }
                %>
                
                <div class="bg-light p-3 rounded-4 mb-4" style="border: 1px dashed #ccc;">
                    <h5 class="mb-1 text-muted">Your Order ID</h5>
                    <h3 class="fw-bold mb-0" style="color: var(--primary);">#<%= (orderId != null) ? orderId : "N/A" %></h3>
                </div>
                
                <div class="d-grid gap-2">
                    <a href="restaurant" class="btn btn-primary-custom py-3 fs-5">Order More Food</a>
                    <a href="orders" class="btn btn-outline-custom py-3 fs-6">View Order History</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Canvas Confetti Library -->
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>

<script>
    // FULL BLASTER CONFETTI EFFECT
    window.onload = function() {
        // 1. Initial massive center explosion
        var count = 200;
        var defaults = { origin: { y: 0.7 } };

        function fire(particleRatio, opts) {
            confetti(Object.assign({}, defaults, opts, {
                particleCount: Math.floor(count * particleRatio)
            }));
        }

        fire(0.25, { spread: 26, startVelocity: 55 });
        fire(0.2, { spread: 60 });
        fire(0.35, { spread: 100, decay: 0.91, scalar: 0.8 });
        fire(0.1, { spread: 120, startVelocity: 25, decay: 0.92, scalar: 1.2 });
        fire(0.1, { spread: 120, startVelocity: 45 });

        // 2. Continuous side cannons firing for 5 seconds
        var end = Date.now() + (5 * 1000);
        var colors = ['#e23744', '#1ba672', '#ffb800', '#007bff', '#ff6b35'];

        (function frame() {
            // Left cannon
            confetti({
                particleCount: 5,
                angle: 60,
                spread: 55,
                origin: { x: 0, y: 0.8 },
                colors: colors
            });
            // Right cannon
            confetti({
                particleCount: 5,
                angle: 120,
                spread: 55,
                origin: { x: 1, y: 0.8 },
                colors: colors
            });

            if (Date.now() < end) {
                requestAnimationFrame(frame);
            }
        }());
    };
</script>

</body>
</html>