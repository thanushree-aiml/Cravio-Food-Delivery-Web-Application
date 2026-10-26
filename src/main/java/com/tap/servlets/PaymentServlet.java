package com.tap.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.tap.util.RazorpayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/createPaymentOrder")
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            // Amount should be in paise (multiply by 100)
            int amount = Integer.parseInt(req.getParameter("amount")) * 100;

            RazorpayClient razorpay = new RazorpayClient(RazorpayConfig.KEY_ID, RazorpayConfig.KEY_SECRET);
            
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amount);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "order_rcptid_" + System.currentTimeMillis());

            Order order = razorpay.orders.create(orderRequest);
            
            // --- THE FIX IS HERE ---
            // Explicitly convert the Object to a String using .toString()
            String orderId = order.get("id").toString();
            
            JSONObject responseJson = new JSONObject();
            responseJson.put("orderId", orderId);
            
            out.print(responseJson.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Failed to create order\"}");
        }
    }
}