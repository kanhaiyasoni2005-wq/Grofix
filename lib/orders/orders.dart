
import 'package:flutter/material.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/orders/ordersdetails.dart';
import 'package:provider/provider.dart';
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<Viewmodel>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<Viewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("My Orders")
      ),

      body: vm.orders.isEmpty
          ? Center(child: Text("No Orders Found"))
          : ListView.builder(
              itemCount: vm.orders.length,
              itemBuilder: (context, index){

                var order = vm.orders[index];
                print(order);

                return Card(
  margin: EdgeInsets.all(8),
  child: ListTile(
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OrderDetailScreen(order: order);
      }));
    },

    title: Text("Total: ₹${order["totalPrice"]}"),

    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Items: ${order["totalItems"]}"),
        Text("Payment: ${order["paymentMethod"]}"),
        SizedBox(height: 5),

        // 🔥 STATUS SHOW
        Text(
          "Status: ${order["status"]}",
          style: TextStyle(
            color: getStatusColor(order["status"]),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),

    trailing: Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // 🔥 CANCEL BUTTON (only pending)
        if (order["status"] == "pending")
          TextButton(
            onPressed: () async {
              await vm.cancelOrder(order["id"]);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
      ],
    ),
  ),
);
              },
            ),
    );
  }
  Color getStatusColor(String status) {
  switch (status) {
    case "paid":
      return Colors.green;
    case "dispatched":
      return Colors.orange;
    case "failed":
      return Colors.red;
    case "cancelled":
      return Colors.grey;
    default:
      return Colors.black;
  }
}
}


