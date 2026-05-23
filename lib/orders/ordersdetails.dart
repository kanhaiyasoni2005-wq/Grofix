
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grofix/repository/widgets/order_action_buttons.dart';
import 'package:grofix/repository/widgets/order_tracking_widget.dart';


class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
   


  DateTime? deliveredTime;

if (order["deliveredTime"] is Timestamp) {
  deliveredTime = (order["deliveredTime"] as Timestamp).toDate();
} else if (order["deliveredTime"] is DateTime) {
  deliveredTime = order["deliveredTime"] as DateTime;
} else if (order["deliveredTime"] is String) {
  deliveredTime = DateTime.tryParse(order["deliveredTime"]);
} else {
  deliveredTime = null;
}

    var products = order["products"];
    String status = (order["status"] ?? "order placed").toString().toLowerCase();

    // ✅ NULL CHECK
    if (products == null || products.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Order Details")
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ CALCULATIONS
    int totalItems = 0;
    double grandTotal = 0;

    for (var item in products) {
      totalItems += (item["quantity"] ?? 0) as int;
      grandTotal += (item["total"] ?? 0).toDouble();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Order Details")
      ),

      body: SingleChildScrollView(
  child: Column(
    children: [

      // 🔥 PRODUCT LIST (NO EXPANDED)
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {

          var item = products[index];

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              children: [

                CachedNetworkImage(
                  imageUrl: item["image"] ?? "",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        item["name"] ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text(
                        item["Description"] ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey),
                      ),

                      SizedBox(height: 5),

                      Text("Qty: ${item["quantity"] ?? 0}"),
                      Text("Price: ₹${item["price"] ?? 0}"),

                      SizedBox(height: 5),

                      Text(
                        "Total: ₹${item["total"] ?? 0}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // 🔥 ORDER SUMMARY
      Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Order Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Items"),
                Text("$totalItems"),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Grand Total"),
                Text("₹$grandTotal"),
              ],
            ),

            SizedBox(height: 20),

            // 🔥 TRACKING
            OrderTrackingWidget(status: status),
          ],
        ),
      ),

      // 🔥 STATUS
      Text(
        "Status: $status",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: status == "cancelled"
              ? Colors.red
              : Colors.green,
        ),
      ),

      SizedBox(height: 10),

      // 🔥 ACTION BUTTONS
      OrderActionButtons(
 
  status: status,
  orderId: order["id"],
  deliveredTime: deliveredTime, // 👈 ADD THIS
),

      SizedBox(height: 20),
    ],
  ),
),
    );
  }
}


