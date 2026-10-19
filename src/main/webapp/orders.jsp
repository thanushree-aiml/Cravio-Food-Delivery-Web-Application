<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Order, com.tap.model.OrderItem, com.tap.model.Menu" %>
<%@ page import="com.tap.DaoImpl.OrderItemDaoImpl, com.tap.DaoImpl.MenuDaoImpl" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVIO - My Orders</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Include the Navbar -->
<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <h2 class="fw-bold mb-4">My Orders 📦</h2>

    <%
        // 1. Get the list of orders passed by OrdersServlet
        List<Order> ordersList = (List<Order>) request.getAttribute("ordersList");

        // 2. Check if there are any orders
        if (ordersList == null || ordersList.isEmpty()) {
    %>
    
        <!-- Empty State UI -->
        <div class="text-center py-5 bg-white rounded-4 shadow-sm">
            <i class="bi bi-bag-x text-muted" style="font-size: 70px;"></i>
            <h4 class="mt-3 fw-bold">No orders yet</h4>
            <p class="text-muted">Looks like you haven't placed any orders with CRAVIO.</p>
            <a href="restaurant" class="btn btn-primary-custom mt-2 px-4 py-2">Explore Restaurants</a>
        </div>

    <%
        } else {
            // 3. Initialize DAOs to fetch items for each order
            OrderItemDaoImpl itemDao = new OrderItemDaoImpl();
            MenuDaoImpl menuDao = new MenuDaoImpl();

            // 4. Loop through each Order
            for (Order order : ordersList) {
    %>
    
        <!-- Order Card -->
        <div class="card mb-4 shadow-sm border-0 rounded-4">
            
            <!-- Card Header: Order Info -->
            <div class="card-header bg-white border-bottom-0 pt-4 pb-2 d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="fw-bold mb-1">Order #<%= order.getOrderId() %></h5>
                    <p class="text-muted small mb-0">
                        <i class="bi bi-calendar3"></i> <%= order.getOrderDate() %>
                    </p>
                </div>
                <div>
                    <!-- Status Badge -->
                    <span class="badge bg-success rounded-pill px-3 py-2">
                        <i class="bi bi-check-circle-fill me-1"></i> <%= order.getStatus() %>
                    </span>
                </div>
            </div>

            <!-- Card Body: List of Items -->
            <div class="card-body py-2">
                <ul class="list-group list-group-flush">
                    <%
                        // Fetch items belonging to THIS specific order
                        List<OrderItem> orderItems = itemDao.getOrderItemsByOrder(order.getOrderId());
                        
                        for (OrderItem item : orderItems) {
                            // Fetch menu details using the menuId from the order item
                            Menu menu = menuDao.getMenu(item.getMenuId());
                            
                            // Safety check: what if the menu item was deleted from the DB?
                            if (menu != null) {
                    %>
                    
                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 border-0 py-3">
                        <div class="d-flex align-items-center gap-3">
                            <!-- Food Image -->
                            <img src="<%= menu.getImagePath() %>" alt="<%= menu.getItemName() %>" 
                                 style="width: 60px; height: 60px; object-fit: cover; border-radius: 10px;">
                            <div>
                                <h6 class="mb-1 fw-bold text-dark"><%= menu.getItemName() %></h6>
                                <small class="text-muted">Qty: <%= item.getQuantity() %></small>
                            </div>
                        </div>
                        <span class="fw-bold text-dark">₹<%= String.format("%.2f", item.getTotalAmount()) %></span>
                    </li>
                    
                    <% 
                            } // end if menu != null
                        } // end for orderItems
                    %>
                </ul>
            </div>

            <!-- Card Footer: Payment & Total -->
            <div class="card-footer bg-light border-top-0 pt-3 pb-3 rounded-bottom-4 d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-muted small">
                        Paid via: <strong><%= order.getPaymentMode() %></strong>
                    </span>
                </div>
                <div>
                    <span class="text-muted me-2">Total Amount:</span>
                    <span class="fs-5 fw-bold" style="color: #e23744;">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
            </div>
            
        </div>
        <!-- End Order Card -->

    <%
            } // end for ordersList
        } // end else
    %>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>