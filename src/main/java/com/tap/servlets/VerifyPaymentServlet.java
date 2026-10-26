package com.tap.servlets;

import java.io.IOException;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import com.tap.util.RazorpayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/verifyPayment")
public class VerifyPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String razorpayOrderId = req.getParameter("razorpay_order_id");
        String razorpayPaymentId = req.getParameter("razorpay_payment_id");
        String razorpaySignature = req.getParameter("razorpay_signature");

        try {
            JSONObject options = new JSONObject();
            options.put("razorpay_order_id", razorpayOrderId);
            options.put("razorpay_payment_id", razorpayPaymentId);
            options.put("razorpay_signature", razorpaySignature);

            // Verify the signature
            boolean isSignatureValid = Utils.verifyPaymentSignature(options, RazorpayConfig.KEY_SECRET);

            if (isSignatureValid) {
                // Payment is successful. 
                // You should now update your database: 
                // 1. Mark the order as 'PAID' in the `orders` table.
                // 2. Clear the user's cart.
                resp.sendRedirect("order_success.jsp"); 
            } else {
                resp.sendRedirect("checkout.jsp?error=Payment verification failed");
            }
        } catch (RazorpayException e) {
            e.printStackTrace();
            resp.sendRedirect("checkout.jsp?error=Payment processing error");
        }
    }
}