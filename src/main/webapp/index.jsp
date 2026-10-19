<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Restaurant" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVIO - Discover the Best Food in Bengaluru</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Include the Navbar (handles theme toggle, login, and location) -->
<jsp:include page="navbar.jsp" />

<!-- ==========================================
     1. HERO SECTION
     ========================================== -->
<div class="hero-section">
    <div class="container">
        <h1>Discover the best food & drinks in Bengaluru</h1>
        <p>Order from your favourite restaurants and get it delivered to your doorstep.</p>
        
        <!-- Search Form routes to RestaurantServlet with the 'q' parameter -->
        <form action="restaurant" method="GET" class="hero-search-box">
            <i class="bi bi-search text-muted align-self-center ms-3"></i>
            <input type="text" name="q" placeholder="Search for restaurant, cuisine or a dish">
            <button type="submit">Search</button>
        </form>
    </div>
</div>

<div class="container my-5">
    
    <!-- ==========================================
         2. CATEGORIES SECTION
         ========================================== -->
    <h3 class="fw-bold mb-3">What's on your mind?</h3>
    <div class="category-scroll">
        <a href="restaurant?q=Biryani" class="category-item text-decoration-none">
            <img src="https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=200&q=80" class="category-img-circle" alt="Biryani">
            <h6>Biryani</h6>
        </a>
        <a href="restaurant?q=Pizza" class="category-item text-decoration-none">
            <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200&q=80" class="category-img-circle" alt="Pizza">
            <h6>Pizza</h6>
        </a>
        <a href="restaurant?q=Burger" class="category-item text-decoration-none">
            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&q=80" class="category-img-circle" alt="Burger">
            <h6>Burger</h6>
        </a>
        <a href="restaurant?q=South Indian" class="category-item text-decoration-none">
            <img src="https://images.unsplash.com/photo-1630383249896-424e482df921?w=200&q=80" class="category-img-circle" alt="Dosa">
            <h6>South Indian</h6>
        </a>
        <a href="restaurant?q=North Indian" class="category-item text-decoration-none">
            <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=200&q=80" class="category-img-circle" alt="North Indian">
            <h6>North Indian</h6>
        </a>
        <a href="restaurant?q=Chinese" class="category-item text-decoration-none">
            <img src="https://images.unsplash.com/photo-1585032226651-759b368d7246?w=200&q=80" class="category-img-circle" alt="Chinese">
            <h6>Chinese</h6>
        </a>
        <a href="restaurant?q=Dessert" class="category-item text-decoration-none">
            <img src="https://images.unsplash.com/photo-1551024506-0bccd828d307?w=200&q=80" class="category-img-circle" alt="Dessert">
            <h6>Desserts</h6>
        </a>
    </div>

    <hr class="my-5" style="border-color: var(--border);">

    <!-- ==========================================
         3. FEATURED RESTAURANTS SECTION
         ========================================== -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h3 class="fw-bold mb-1">Featured Restaurants</h3>
            <p class="text-muted mb-0">Top picks near you</p>
        </div>
        <!-- EXPLORE ALL BUTTON -->
        <a href="restaurant" class="btn btn-primary-custom px-4 py-2">
            Explore All <i class="bi bi-arrow-right ms-1"></i>
        </a>
    </div>
    
    <div class="row g-4">
        <%
            // Get the featured restaurants passed by HomeServlet
            List<Restaurant> featured = (List<Restaurant>) request.getAttribute("featuredRestaurants");
            if (featured != null && !featured.isEmpty()) {
                for (Restaurant r : featured) {
        %>
        <div class="col-md-6 col-lg-3">
            <a href="menu?restaurantId=<%= r.getRestaurantId() %>" class="text-decoration-none">
                <div class="custom-card h-100">
                    <div class="position-relative">
                        <img src="<%= r.getImagePath() %>" alt="<%= r.getName() %>" 
                             style="height: 160px; width: 100%; object-fit: cover;">
                        <div class="position-absolute bottom-0 start-0 m-2">
                            <span class="badge bg-dark bg-opacity-75 text-white px-2 py-1 rounded-2 small">
                                <i class="bi bi-clock me-1"></i> <%= r.getDeliveryTime() %> mins
                            </span>
                        </div>
                    </div>
                    <div class="card-body-custom p-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <h6 class="fw-bold text-dark mb-0 text-truncate" style="max-width: 70%;"><%= r.getName() %></h6>
                            <span class="badge bg-success px-2 py-1"><%= r.getRating() %> <i class="bi bi-star-fill" style="font-size: 10px;"></i></span>
                        </div>
                        <p class="text-muted small mb-0 text-truncate"><%= r.getCuisineType() %></p>
                    </div>
                </div>
            </a>
        </div>
        <%      
                }
            } else { 
        %>
            <!-- Fallback if HomeServlet is not implemented yet -->
            <div class="col-12 text-center py-4">
                <p class="text-muted">Loading featured restaurants... (Make sure HomeServlet is configured)</p>
            </div>
        <%  } %>
    </div>
</div>

<!-- ==========================================
     4. FOOTER
     ========================================== -->
<footer class="bg-dark text-white text-center py-4 mt-5">
    <div class="container">
        <h5 class="fw-bold mb-2">CRAVIO</h5>
        <p class="mb-0 text-muted small">© 2024 CRAVIO. Built with ❤️ for Food Lovers in Bengaluru.</p>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>