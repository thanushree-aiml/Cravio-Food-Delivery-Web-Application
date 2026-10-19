<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Order" %>
<!DOCTYPE html>
<html>
<head>
    <title>CRAVIO - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <h2 class="fw-bold mb-4">Admin Dashboard - All Orders</h2>
    
    <div class="table-responsive custom-card p-4">
        <table class="table table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Order ID</th>
                    <th>User ID</th>
                    <th>Restaurant ID</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Payment Mode</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Order> allOrders = (List<Order>) request.getAttribute("allOrders");
                    if(allOrders != null) {
                        for(Order o : allOrders) {
                %>
                <tr>
                    <td>#<%= o.getOrderId() %></td>
                    <td><%= o.getUserId() %></td>
                    <td><%= o.getRestaurantId() %></td>
                    <td>₹<%= o.getTotalAmount() %></td>
                    <td><span class="badge bg-warning text-dark"><%= o.getStatus() %></span></td>
                    <td><%= o.getPaymentMode() %></td>
                    <td>
                        <!-- In the future, this form will update the DB -->
                        <form action="updateOrderStatus" method="post" class="d-flex gap-2">
                            <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                            <select name="status" class="form-select form-select-sm" style="width: 130px;">
                                <option value="PLACED">PLACED</option>
                                <option value="PREPARING">PREPARING</option>
                                <option value="OUT_FOR_DELIVERY">OUT FOR DELIVERY</option>
                                <option value="DELIVERED">DELIVERED</option>
                            </select>
                            <button type="submit" class="btn btn-sm btn-primary-custom">Update</button>
                        </form>
                    </td>
                </tr>
                <%      }
                    } %>
            </tbody>
        </table>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/main.js"></script>
</body>
</html>