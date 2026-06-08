import 'package:flutter/material.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:provider/provider.dart';


class OrderActionButtons extends StatefulWidget {
  final String status;
  final String orderId;
  final DateTime? deliveredTime; // 👈 ADD THIS
 

  const OrderActionButtons({
    super.key,
    required this.status,
    required this.orderId,

    required this.deliveredTime,
  });

  @override
  State<OrderActionButtons> createState() => _OrderActionButtonsState();
}

class _OrderActionButtonsState extends State<OrderActionButtons> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // ✅ FIX: normalize status
    final currentStatus = widget.status.toLowerCase().trim();

    // 🔥 DEBUG PRINT
    print("Status: $currentStatus | deliveredTime: ${widget.deliveredTime}");

    // 4 hours ka difference check
    Duration? difference;
    
    if (widget.deliveredTime != null) {
      difference = now.difference(widget.deliveredTime!);
      print("Difference in minutes: ${difference.inMinutes}");
    }

    final isWithin4Hours = difference != null &&
        difference.inMinutes >= 0 &&
        difference.inMinutes <= 240;

    print("IsWithin4Hours: $isWithin4Hours");

    bool canCancel = [
  "order placed",
  "order confirmed",
  "out for delivery",
  "dispatched" // optional (अगर use करते हो)
].contains(currentStatus);

    // ✅ RETURN should be allowed only if delivered and within 4 hours
    bool canReturn = currentStatus == "delivered" && isWithin4Hours;
    
    print("CanReturn: $canReturn (isWithin4Hours: $isWithin4Hours, status: $currentStatus)");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [

          // 🔴 CANCEL BUTTON
          if (canCancel)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  var vm = Provider.of<Viewmodel>(context, listen: false);
                  await vm.cancelOrder(widget.orderId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Cancelled")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Cancel Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),

          const SizedBox(height: 10),

          // 🔁 RETURN BUTTON
          if (canReturn)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  var vm = Provider.of<Viewmodel>(context, listen: false);
                  await vm.returnOrder(widget.orderId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Return Requested")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Return Order"),
              ),
            ),

          if (!canCancel && !canReturn)
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}


