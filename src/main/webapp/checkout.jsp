<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart, com.tap.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRAVIO - Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="auth-card">
                <h2 class="fw-bold mb-4">Checkout</h2>

                <%
                    User user = (User) session.getAttribute("loggedInUser");
                    Cart cart = (Cart) session.getAttribute("cart");
                    double grandTotal = cart.getSubtotal() + 40.00;
                %>

                <form action="placeOrder" method="post">
                    <!-- Delivery Address -->
                    <div class="mb-4">
                        <h5 class="fw-bold text-primary mb-3"><i class="bi bi-geo-alt-fill"></i> Delivery Address</h5>
                        <div class="bg-light p-3 rounded-3">
                            <strong><%= user.getUsername() %></strong><br>
                            <%= user.getAddress() != null ? user.getAddress() : "No address saved. Please update your profile." %><br>
                            Phone: <%= user.getPhone() %>
                        </div>
                    </div>

                    <!-- Order Summary -->
                    <div class="mb-4">
                        <h5 class="fw-bold text-primary mb-3"><i class="bi bi-bag-fill"></i> Order Summary</h5>
                        <div class="bg-light p-3 rounded-3">
                            <p class="mb-1">Items: <strong><%= cart.getItemCount() %></strong></p>
                            <p class="mb-1">Subtotal: <strong>₹<%= String.format("%.2f", cart.getSubtotal()) %></strong></p>
                            <p class="mb-0">Delivery Fee: <strong>₹40.00</strong></p>
                            <hr>
                            <div class="d-flex justify-content-between fs-5 fw-bold">
                                <span>Total:</span>
                                <span>₹<%= String.format("%.2f", grandTotal) %></span>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Mode -->
                    <div class="mb-4">
                        <h5 class="fw-bold text-primary mb-3"><i class="bi bi-credit-card-fill"></i> Payment Mode</h5>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="paymentMode" value="Cash on Delivery" id="cod" checked>
                            <label class="form-check-label" for="cod">Cash on Delivery</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="paymentMode" value="Credit Card" id="cc">
                            <label class="form-check-label" for="cc">Credit / Debit Card</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMode" value="UPI" id="upi">
                            <label class="form-check-label" for="upi">UPI (GPay, PhonePe)</label>
                        </div>
                    </div>

                    <input type="hidden" name="restaurantId" value="<%= cart.getRestaurantId() %>">
                    <input type="hidden" name="totalAmount" value="<%= grandTotal %>">

                    <button type="submit" class="btn btn-primary-custom w-100 py-3 fs-5">Place Order</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Add this script in the <head> of checkout.jsp -->
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<!-- ... (Your existing checkout form) ... -->
<!-- Change your "Place Order" button to call the Razorpay function -->
<button type="button" id="rzp-button" class="btn btn-primary-custom w-100 py-3 fs-5">Pay with Razorpay</button>

<!-- Hidden form to submit payment details for verification -->
<form id="paymentForm" action="verifyPayment" method="post" style="display:none;">
    <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
    <input type="hidden" name="razorpay_order_id" id="razorpay_order_id">
    <input type="hidden" name="razorpay_signature" id="razorpay_signature">
</form>

<script>
document.getElementById('rzp-button').onclick = function(e){
    e.preventDefault();
    
    // 1. Call your backend to create the Razorpay Order
    fetch('createPaymentOrder', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'amount=' + document.getElementById('totalAmount').value // Ensure you have this hidden input
    })
    .then(response => response.json())
    .then(data => {
        if (data.error) {
            alert("Error creating order. Please try again.");
            return;
        }

        // 2. Configure Razorpay Checkout
        var options = {
            "key": "<%= com.tap.util.RazorpayConfig.KEY_ID %>", // Your Key ID
            "amount": document.getElementById('totalAmount').value * 100, // Amount in paise
            "currency": "INR",
            "name": "CRAVIO",
            "description": "Food Delivery Order",
            "order_id": data.orderId, // The order ID from your backend
            "handler": function (response){
                // 3. On success, submit the details to your verification servlet
                document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                document.getElementById('razorpay_signature').value = response.razorpay_signature;
                document.getElementById('paymentForm').submit();
            },
            "prefill": {
                "name": "<%= ((User)session.getAttribute("loggedInUser")).getUsername() %>",
                "email": "<%= ((User)session.getAttribute("loggedInUser")).getEmail() %>",
                "contact": "<%= ((User)session.getAttribute("loggedInUser")).getPhone() %>"
            },
            "theme": {
                "color": "#e23744" // CRAVIO Red
            }
        };
        var rzp1 = new Razorpay(options);
        rzp1.open();
    })
    .catch(error => {
        console.error('Error:', error);
        alert("Something went wrong. Please check your connection.");
    });
};
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>