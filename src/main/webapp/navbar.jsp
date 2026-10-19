<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentURI = request.getRequestURI();
    com.tap.model.User navUser = (com.tap.model.User) session.getAttribute("loggedInUser");
%>

<nav class="navbar navbar-expand-lg custom-navbar sticky-top">
    <div class="container-fluid px-4">
        <!-- Logo & Location -->
        <div class="d-flex align-items-center">
            <a class="navbar-brand me-3" href="home">CRAVIO</a>
            
            <!-- Location Dropdown (Hidden on mobile) -->
            <div class="dropdown d-none d-md-block border-start ps-3">
                <a class="location-picker dropdown-toggle text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                    <i class="bi bi-geo-alt-fill text-danger fs-5"></i>
                    <span>Bengaluru</span>
                </a>
                <ul class="dropdown-menu shadow border-0 mt-2">
                    <li><h6 class="dropdown-header">Popular Places</h6></li>
                    <li><a class="dropdown-item" href="restaurant?location=Koramangala">Koramangala</a></li>
                    <li><a class="dropdown-item" href="restaurant?location=Indiranagar">Indiranagar</a></li>
                    <li><a class="dropdown-item" href="restaurant?location=Whitefield">Whitefield</a></li>
                    <li><a class="dropdown-item" href="restaurant?location=Jayanagar">Jayanagar</a></li>
                    <li><a class="dropdown-item" href="restaurant?location=HSR Layout">HSR Layout</a></li>
                </ul>
            </div>
        </div>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- SEARCH BAR IN NAVBAR -->
            <form class="nav-search-form d-none d-lg-block mx-auto" action="restaurant" method="GET">
                <input type="text" name="q" class="nav-search-input" placeholder="Search for restaurant, cuisine...">
            </form>

            <!-- Nav Links -->
            <ul class="navbar-nav align-items-center ms-auto">
                <li class="nav-item">
                    <a class="nav-link <%= currentURI.contains("home") || currentURI.contains("index") ? "active" : "" %>" href="home">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= currentURI.contains("restaurant") || currentURI.contains("menu") ? "active" : "" %>" href="restaurant">Restaurants</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= currentURI.contains("orders") ? "active" : "" %>" href="orders">Orders</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= currentURI.contains("cart") ? "active" : "" %>" href="cart">
                        <i class="bi bi-cart3"></i> Cart
                    </a>
                </li>

                <!-- Admin Link (Only shows for ADMIN role) -->
                <% if (navUser != null && "ADMIN".equals(navUser.getRole())) { %>
                    <li class="nav-item">
                        <a class="nav-link text-danger fw-bold" href="admin">Admin Panel</a>
                    </li>
                <% } %>

                <% if (navUser != null) { %>
                    <li class="nav-item ms-lg-3 dropdown">
                        <a class="nav-link dropdown-toggle fw-bold" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle fs-5 align-middle"></i> <%= navUser.getUsername() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><a class="dropdown-item" href="logout">Logout</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item ms-lg-3">
                        <a class="btn btn-primary-custom btn-sm px-4 py-2" href="login.jsp">Login</a>
                    </li>
                <% } %>

                <!-- Theme Toggle Button -->
                <li class="nav-item ms-lg-3">
                    <button class="btn btn-link nav-link" id="themeButton" onclick="toggleTheme()">
                        <i class="bi bi-moon-stars" id="themeIcon"></i>
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>
<% if (navUser != null && "ADMIN".equals(navUser.getRole())) { %>
    <li class="nav-item">
        <a class="nav-link text-danger fw-bold" href="admin">Admin Panel</a>
    </li>
<% } %>
<!-- ==============================================
     INLINE JAVASCRIPT FOR THEME TOGGLE
     ============================================== -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 1. Check if user previously saved a theme
        const savedTheme = localStorage.getItem("theme");
        const themeIcon = document.getElementById("themeIcon");
        
        if (savedTheme === "dark") {
            document.body.classList.add("dark");
            if(themeIcon) themeIcon.className = "bi bi-sun";
        } else {
            if(themeIcon) themeIcon.className = "bi bi-moon-stars";
        }

        // 2. The Toggle Function
        window.toggleTheme = function() {
            document.body.classList.toggle("dark");
            
            if (document.body.classList.contains("dark")) {
                themeIcon.className = "bi bi-sun";
                localStorage.setItem("theme", "dark");
            } else {
                themeIcon.className = "bi bi-moon-stars";
                localStorage.setItem("theme", "light");
            }
        };
    });
</script>