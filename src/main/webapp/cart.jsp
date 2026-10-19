<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection" %>
<%@ page import="com.tap.model.Cart, com.tap.model.CartItem" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVIO - Your Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <%
        Cart cart = (Cart) request.getAttribute("cart");
        if (cart == null) { cart = new Cart(); }
        Collection<CartItem> cartItems = cart.getItems().values();
    %>

    <h2 class="fw-bold mb-4">Your Cart 🛒</h2>

    <% if (cartItems.isEmpty()) { %>
        <!-- Empty State UI -->
        <div class="text-center py-5 bg-white rounded-4 shadow-sm">
            <i class="bi bi-cart-x text-muted" style="font-size: 70px;"></i>
            <h4 class="mt-3 fw-bold">Your cart is empty</h4>
            <p class="text-muted">Looks like you haven't added anything to your cart yet.</p>
            <a href="restaurant" class="btn btn-primary-custom mt-2 px-4 py-2">Browse Restaurants</a>
        </div>
    <% } else { %>
        <div class="row g-4">
            <!-- Left Side: List of Cart Items -->
            <div class="col-lg-8">
                <div class="bg-white rounded-4 shadow-sm p-4">
                    <% for (CartItem item : cartItems) { %>
                    <div class="d-flex gap-3 py-3 border-bottom align-items-center">
                        <img src="<%= item.getMenu().getImagePath() %>" alt="<%= item.getMenu().getItemName() %>" 
                             style="width: 100px; height: 100px; object-fit: cover; border-radius: 12px;">
                        
                        <div class="flex-grow-1">
                            <h5 class="fw-bold mb-1"><%= item.getMenu().getItemName() %></h5>
                            <p class="text-muted small mb-2">₹<%= String.format("%.0f", item.getMenu().getPrice()) %> per item</p>
                            
                            <!-- Quantity Controls inside Cart -->
                            <div class="d-flex align-items-center gap-2">
                                <form action="cart" method="post" class="m-0">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
                                    <input type="hidden" name="source" value="cart">
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                    <button type="submit" class="btn btn-sm btn-outline-secondary rounded-circle" style="width: 30px; height: 30px; padding: 0;"><i class="bi bi-dash"></i></button>
                                </form>
                                
                                <span class="fw-bold fs-5 px-2"><%= item.getQuantity() %></span>
                                
                                <form action="cart" method="post" class="m-0">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
                                    <input type="hidden" name="source" value="cart">
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                    <button type="submit" class="btn btn-sm btn-outline-secondary rounded-circle" style="width: 30px; height: 30px; padding: 0;"><i class="bi bi-plus"></i></button>
                                </form>
                            </div>
                        </div>
                        
                        <div class="text-end">
                            <h5 class="fw-bold mb-3">₹<%= String.format("%.0f", item.getSubtotal()) %></h5>
                            <form action="cart" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
                                <button type="submit" class="btn btn-link text-danger p-0 small text-decoration-none">
                                    <i class="bi bi-trash"></i> Remove
                                </button>
                            </form>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Right Side: Bill Summary -->
            <div class="col-lg-4">
                <div class="bg-white rounded-4 shadow-sm p-4" style="position: sticky; top: 90px;">
                    <h4 class="fw-bold mb-4">Bill Details</h4>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Item Total</span>
                        <span class="fw-semibold">₹<%= String.format("%.0f", cart.getSubtotal()) %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Delivery Fee</span>
                        <span class="fw-semibold text-success">FREE</span>
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between mb-4">
                        <span class="fw-bold fs-5">To Pay</span>
                        <span class="fw-bold fs-5">₹<%= String.format("%.0f", cart.getSubtotal()) %></span>
                    </div>

                    <!-- Checkout Button -->
                    <a href="checkout" class="btn btn-primary-custom w-100 py-3 fs-5 mb-3">
                        Proceed to Checkout <i class="bi bi-arrow-right"></i>
                    </a>
                    
                    <form action="cart" method="post">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="btn btn-outline-danger w-100">Clear Cart</button>
                    </form>
                </div>
            </div>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>