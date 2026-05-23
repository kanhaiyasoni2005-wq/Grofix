
import 'package:flutter/material.dart';
import 'package:grofix/orders/orders.dart';
import 'package:grofix/repository/screens/bottomNav/bottomnavigation.dart';

class OrderPlacedScreen extends StatelessWidget {


  const OrderPlacedScreen({
    super.key,
 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// ✅ Success Icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),

              SizedBox(height: 25),

              /// 🎉 Title
              Text(
                "Order Confirmed!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              /// 📦 Subtitle
              Text(
                "Your order has been placed successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 25),

              /// ⏱ Delivery Info
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      "Delivery in  15 minutes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// 🧾 Order ID
              Text(
                "Thanks for booking",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 40),

              /// 🔘 Track Order Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderScreen()));
                    // 👉 Navigate to tracking screen
                  },
                  child: Text("Track Order"),
                ),
              ),

              SizedBox(height: 10),

              /// 🛍 Continue Shopping
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottomnavigation()));
                },
                child: Text("Continue Shopping"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


