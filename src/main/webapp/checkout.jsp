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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>