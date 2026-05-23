import 'package:flutter/material.dart';

class OrderTrackingWidget extends StatelessWidget {
  final String status;

  const OrderTrackingWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final currentStatus = status.toLowerCase().trim();

    bool isCancelled = currentStatus == "cancelled";

    List<Map<String, dynamic>> steps;

    // ❌ CANCELLED
    if (isCancelled) {
      steps = [
        {
          "title": "Order Placed",
          "subtitle": "Your order was placed",
          "done": true,
        },
        {
          "title": "Cancelled",
          "subtitle": "Your order has been cancelled",
          "done": true,
        },
      ];
    }

    // 🔥 RETURN REQUESTED
    else if (currentStatus == "return_requested") {
      steps = [
        {
          "title": "Return Requested",
          "subtitle": "Your return request has been placed",
          "done": true,
        },
        {
          "title": "Return Accepted",
          "subtitle": "Waiting for approval",
          "done": false,
        },
      ];
    }

    // 🔥 RETURN ACCEPTED
    else if (currentStatus == "return_accepted") {
      steps = [
        {
          "title": "Return Requested",
          "subtitle": "Your return request has been placed",
          "done": true,
        },
        {
          "title": "Return Accepted",
          "subtitle": "Your return request has been approved",
          "done": true,
        },
      ];
    }

    // 🔥 NORMAL ORDER FLOW
    else {
      steps = [
        {
          "title": "Order Placed",
          "subtitle": "Your order was placed",
          "done": true,
        },
        {
          "title": "Order Confirmed",
          "subtitle": "Your order has been confirmed",
          "done": [
            "order confirmed",
            "dispatched",
            "out for delivery",
            "delivered"
          ].contains(currentStatus),
        },
        {
          "title": "Order Dispatched",
          "subtitle": "Your order has been dispatched",
          "done": [
            "dispatched",
            "order dispatched",
            "out for delivery",
            "delivered"
          ].contains(currentStatus),
        },
        {
          "title": "Out for Delivery",
          "subtitle": "Your order is on the way",
          "done": ["out for delivery", "delivered"].contains(currentStatus),
        },
        {
          "title": "Delivered",
          "subtitle": "Your order has been delivered",
          "done": currentStatus == "delivered",
        },
      ];
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        bool isDone = steps[index]["done"];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDone ? Colors.orange : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 50,
                    color: isDone ? Colors.orange : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[index]["title"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDone ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      steps[index]["subtitle"],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

