<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Restaurant"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVIO - Restaurants</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container my-5">
    <%
        // Display the search query if it exists
        String searchQuery = (String) request.getAttribute("searchQuery");
        if (searchQuery != null && !searchQuery.isEmpty()) {
    %>
        <h2 class="fw-bold mb-4">Search Results for "<%= searchQuery %>"</h2>
    <%
        } else {
    %>
        <h2 class="fw-bold mb-4">Top Restaurant Chains in Bengaluru</h2>
    <%
        }
    %>

    <div class="row g-4">
        <%
            List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
            if (restaurants != null && !restaurants.isEmpty()) {
                for (Restaurant r : restaurants) {
        %>
        <div class="col-md-6 col-lg-4 col-xl-3">
            <a href="menu?restaurantId=<%= r.getRestaurantId() %>" class="text-decoration-none">
                <div class="custom-card h-100">
                    <div class="position-relative">
                        <img src="<%= r.getImagePath() %>" alt="<%= r.getName() %>" style="height: 180px; width: 100%; object-fit: cover;">
                        <div class="position-absolute bottom-0 start-0 m-2">
                            <span class="badge bg-dark bg-opacity-75 text-white px-2 py-1 rounded-2 small">
                                <i class="bi bi-clock me-1"></i> <%= r.getDeliveryTime() %> mins
                            </span>
                        </div>
                    </div>
                    
                    <div class="card-body-custom">
                        <div class="d-flex justify-content-between align-items-start mb-1">
                            <h5 class="fw-bold text-dark mb-0 text-truncate" style="max-width: 70%;"><%= r.getName() %></h5>
                            <span class="badge bg-success d-flex align-items-center gap-1 px-2 py-1">
                                <span><%= r.getRating() %></span>
                                <i class="bi bi-star-fill text-white" style="font-size: 10px;"></i>
                            </span>
                        </div>
                        <p class="text-muted small text-truncate mb-2"><%= r.getCuisineType() %></p>
                        <p class="text-muted small text-truncate mb-0 border-top pt-2">
                            <i class="bi bi-geo-alt-fill text-danger me-1"></i> <%= r.getAddress() %>
                        </p>
                    </div>
                </div>
            </a>
        </div>
        <%
                }
            } else {
        %>
            <div class="col-12 text-center py-5">
                <h4 class="text-muted">No restaurants found for "<%= searchQuery %>".</h4>
                <p>Try searching for something else.</p>
                <a href="restaurant" class="btn btn-primary-custom mt-2">View All Restaurants</a>
            </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/main.js"></script>
</body>
</html>