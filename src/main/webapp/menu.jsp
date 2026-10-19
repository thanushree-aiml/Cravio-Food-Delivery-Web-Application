<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Menu, com.tap.model.Restaurant, com.tap.model.Cart, com.tap.model.CartItem" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVIO - Menu</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Custom Premium CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Include Navbar -->
<jsp:include page="navbar.jsp" />

<!-- ==========================================
     TOAST NOTIFICATION (Slides up from bottom)
     ========================================== -->
<% 
    String addedParam = request.getParameter("added");
    String addedQty = request.getParameter("qty");
    if ("true".equals(addedParam)) { 
%>
<div class="toast-container position-fixed bottom-0 start-50 translate-middle-x p-3" style="z-index: 1050;">
    <div class="toast show align-items-center text-white bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex w-100 justify-content-between align-items-center" style="min-width: 280px;">
            <div class="toast-body fs-6 fw-semibold">
                <i class="bi bi-check-circle-fill me-2"></i> <%= (addedQty != null ? addedQty : "1") %> item(s) added to cart
            </div>
            <a href="cart" class="btn btn-success fw-bold me-2 my-auto px-3 text-white" style="border-left: 1px solid rgba(255,255,255,0.3); text-decoration: none;">VIEW CART</a>
        </div>
    </div>
</div>
<% } %>

<div class="container my-5">

    <%
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
        String restaurantName = (restaurant != null) ? restaurant.getName() : "Our Menu";
        
        // Fetch the cart from the session once
        Cart sessionCart = (Cart) session.getAttribute("cart");
    %>

    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h2 class="fw-bold mb-1">Explore <%= restaurantName %></h2>
            <p class="text-muted mb-0">Choose from delicious dishes and add your favourites.</p>
        </div>
        <!-- Quick link to cart -->
        <a href="cart" class="btn btn-outline-custom d-none d-md-block">
            <i class="bi bi-cart3"></i> Go to Cart
        </a>
    </div>

    <div class="row g-4">
        <%
            if (menuList != null && !menuList.isEmpty()) {
                for (Menu menu : menuList) {
                    
                    // 1. Check if this specific item is in the cart
                    int cartQty = 0;
                    if (sessionCart != null && sessionCart.getItems().containsKey(menu.getMenuId())) {
                        cartQty = sessionCart.getItems().get(menu.getMenuId()).getQuantity();
                    }

                    // 2. Veg / Non-Veg Logic (Mock logic based on item name)
                    String itemNameLower = menu.getItemName().toLowerCase();
                    boolean isNonVeg = itemNameLower.contains("chicken") || itemNameLower.contains("mutton") || 
                                       itemNameLower.contains("fish") || itemNameLower.contains("prawn") || 
                                       itemNameLower.contains("kebab") || itemNameLower.contains("egg");
                    String dietClass = isNonVeg ? "non-veg" : "veg";
        %>
        <div class="col-md-6 col-lg-4">
            <div class="custom-card h-100 d-flex flex-column">
                
                <!-- Food Image -->
                <div class="position-relative">
                    <!-- Note: This src will now pull from your local 'images/' folder if you updated the DB -->
                    <img src="<%= menu.getImagePath() %>" alt="<%= menu.getItemName() %>" 
                         style="height: 200px; width: 100%; object-fit: cover;">
                    
                    <% if (!menu.isAvailable()) { %>
                        <div class="position-absolute top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center" 
                             style="background: rgba(0,0,0,0.6);">
                            <span class="badge bg-danger fs-6 px-3 py-2">Currently Unavailable</span>
                        </div>
                    <% } %>
                </div>

                <!-- Card Body -->
                <div class="card-body-custom d-flex flex-column flex-grow-1 pt-3">
                    
                    <!-- Veg Icon + Title + Price -->
                    <div class="d-flex align-items-center mb-1">
                        <div class="diet-icon <%= dietClass %>"></div>
                        <h5 class="fw-bold mb-0 text-truncate" style="max-width: 75%;"><%= menu.getItemName() %></h5>
                    </div>
                    
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="price-text">₹<%= String.format("%.0f", menu.getPrice()) %></span>
                        <span class="text-warning small fw-semibold"><i class="bi bi-star-fill"></i> 4.2</span>
                    </div>

                    <p class="text-muted small mb-4" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                        <%= menu.getDescription() %>
                    </p>
                    
                    <!-- Action Buttons (Bottom of Card) -->
                    <div class="mt-auto">
                        <% if (menu.isAvailable()) { %>
                            
                            <% if (cartQty > 0) { %>
                                <!-- SWIGGY STYLE QUANTITY CONTROLS -->
                                <div class="swiggy-qty-wrapper">
                                    <form action="cart" method="post" class="m-0">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                                        <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantId() %>">
                                        <input type="hidden" name="source" value="menu">
                                        <input type="hidden" name="quantity" value="<%= cartQty - 1 %>">
                                        <button type="submit" class="swiggy-btn"><i class="bi bi-dash"></i></button>
                                    </form>
                                    
                                    <span class="swiggy-qty-text"><%= cartQty %></span>
                                    
                                    <form action="cart" method="post" class="m-0">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                                        <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantId() %>">
                                        <input type="hidden" name="source" value="menu">
                                        <input type="hidden" name="quantity" value="<%= cartQty + 1 %>">
                                        <button type="submit" class="swiggy-btn"><i class="bi bi-plus"></i></button>
                                    </form>
                                </div>
                            <% } else { %>
                                <!-- SWIGGY STYLE CLEAN ADD BUTTON -->
                                <form action="cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantId() %>">
                                    <input type="hidden" name="source" value="menu">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="clean-add-btn">
                                        ADD
                                    </button>
                                </form>
                            <% } %>
                            
                        <% } else { %>
                            <button class="btn btn-secondary w-100 py-2 rounded-3" disabled>Unavailable</button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        <%      }
            } else { %>
            <div class="col-12 text-center py-5">
                <i class="bi bi-egg-fried text-muted" style="font-size: 60px;"></i>
                <h4 class="text-muted mt-3">No menu items available.</h4>
                <a href="restaurant" class="btn btn-primary-custom mt-3">Back to Restaurants</a>
            </div>
        <%  } %>
    </div>
</div>

<!-- Bootstrap JS & Custom JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/main.js"></script>

<!-- Auto-hide Toast after 3 seconds (Optional) -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var toastEl = document.querySelector('.toast');
        if (toastEl) {
            setTimeout(function() {
                var toast = bootstrap.Toast.getInstance(toastEl) || new bootstrap.Toast(toastEl);
                toast.hide();
                // Remove the URL parameters so the toast doesn't show on refresh
                window.history.replaceState({}, document.title, window.location.pathname + "?restaurantId=<%= (restaurant != null) ? restaurant.getRestaurantId() : "" %>");
            }, 3000); 
        }
    });
</script>

</body>
</html>