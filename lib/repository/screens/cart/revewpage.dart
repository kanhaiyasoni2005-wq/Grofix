
import 'package:flutter/material.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/cart/orderConferm.dart';
import 'package:grofix/repository/widgets/userdata.dart';
import 'package:grofix/services/payment.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';


class productReview extends StatefulWidget{
  const productReview({super.key});

  @override
  State<productReview> createState() => _productReviewState();

}

// var a = productOverView(product: product)
class _productReviewState extends State<productReview> {
 
@override void initState() { 
  // TODO: implement initState 
  super.initState(); 
  Future.microtask((){ 
    Provider.of<Viewmodel>(context, listen: false).fatchAdress();
     }); }

  
Future<Position> getLocation() async {

  // 🔴 Check service ON है या नहीं
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception("Location service is OFF");
  }

  // 🔴 Permission check
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception("Permission permanently denied");
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}
  String selectedPayment = "cod";

  bool isPlacingOrder = false;
  @override
  Widget build(BuildContext context) {
   var vm = Provider.of<Viewmodel>(context, );
   var cart = context.watch<Cartprovider>();
    
    // TODO: implement build
    return Scaffold(
appBar: AppBar(
  automaticallyImplyLeading: true,
  title: Text("Reveiw"),
),
body:Stack(
  children: [
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: [
            
            // ================= PRODUCT LIST =================
            ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cart.cartList.length,
      itemBuilder: (context, index) {
        final item = cart.cartList[index];
    
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
    
              // ================= IMAGE (FIXED SIZE) =================
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
  item.image,
  width: 70,
  height: 70,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;

    return SizedBox(
      width: 70,
      height: 70,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  },
),
              ),
    
              SizedBox(width: 10),
    
              // ================= DETAILS =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
    
                    SizedBox(height: 5),
    
                    Text(
                      "₹${item.price}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
    
                    SizedBox(height: 5),
    
                    Text(
                      "Total: ₹${item.quantity * item.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
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
    
            SizedBox(height: 12),
    
            // ================= ADDRESS =================
      Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: vm.selectedAddress == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_off, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("No address selected"),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => userProfile()),
                    );
                  },
                  child: Text("Add"),
                )
              ],
            )
          : Row(
              children: [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 10),
    
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.selectedAddress!["name"] ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(vm.selectedAddress?["phone"]?.toString() ?? ""),
                      Text(
                        vm.selectedAddress!["Address"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
    
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => userProfile()),
                    );
                  },
                  child: Text("Change"),
                ),
              ],
            ),
    ),
    
            // ================= PAYMENT OPTIONS =================
       Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
    
          RadioListTile(
            activeColor: Colors.green,
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Cash on Delivery",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Pay when order arrives"),
            value: "cod",
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value!;
              });
            },
          ),
    
          Divider(height: 1),
    
          RadioListTile(
            activeColor: Colors.green,
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Online Payment",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("UPI / Card / Net Banking"),
            value: "online",
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value!;
              });
            },
          ),
        ],
      ),
    ),
    
            // ================= TOTAL + BUTTON =================
          Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
    
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 5),
              Text(
                "₹${context.watch<Cartprovider>().totalPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
    
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isPlacingOrder ? null : () async {

  setState(() {
    isPlacingOrder = true;
  });

  try {

    // 🔥 YAHAN LOCATION LO
    var vm = Provider.of<Viewmodel>(context, listen: false);
var cart = context.read<Cartprovider>();

if (vm.selectedAddress == null) {

  setState(() {
    isPlacingOrder = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Please select address"))
  );

  return;
}

// 🔥 AB LOCATION LO
Position pos = await getLocation();

double lat = pos.latitude;
double lng = pos.longitude;
    
       if (vm.selectedAddress == null) {

  setState(() {
    isPlacingOrder = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Please select address"))
  );

  return;
}
    
        // 👉 COD FLOW
        if (selectedPayment == "cod") {
    
          var cartItemsCopy = List.from(cart.cartList);
    
          String orderId = await vm.placeOrder(
            cartItems: cartItemsCopy,
            address: vm.selectedAddress!,
            totalPrice: cart.totalPrice,
            paymentMethod: "cod",
            status: "Order Placed",
            lat: lat,
            lng: lng,
          );
    
          await vm.updateOrderStatus(orderId, "Order Placed");
    
          cart.clearCart();
    
          if (!context.mounted) return;
    
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrderPlacedScreen())
          );
        }
    
        // 👉 ONLINE FLOW
        else {

  var cartItemsCopy = List.from(cart.cartList);

  // 🔥 FIRST CREATE CASHFREE ORDER
  var data = await PaymentService.createOrder(cart.totalPrice);

  String cashfreeOrderId = data["order_id"] ?? "";
  String sessionId = data["payment_session_id"] ?? "";

  if (cashfreeOrderId.isEmpty || sessionId.isEmpty) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Unable to start payment"))
  );

  return;
}

  // 🔥 PAYMENT PAGE OPEN FAST
  await PaymentService.startPayment(
    orderId: cashfreeOrderId,
    sessionId: sessionId,

    onSuccess: () async {

      // 🔥 PAYMENT SUCCESS KE BAAD FIRESTORE SAVE
      String firestoreOrderId = await vm.placeOrder(
        cartItems: cartItemsCopy,
        address: vm.selectedAddress!,
        totalPrice: cart.totalPrice,
        paymentMethod: "online",
        status: "Order Placed",
        lat: lat,
        lng: lng,
      );

      await vm.updateOrderStatus(
        firestoreOrderId,
        "Order Placed",
      );

      cart.clearCart();

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderPlacedScreen(),
        ),
      );
    },

    onError: (error) async {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed"))
      );
    },
  );
}
    
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
        );
      } finally {
        if (mounted) {
          setState(() {
            isPlacingOrder = false;
          });
        }
      }
    },
            child: isPlacingOrder
    ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
    : Text(
        "Place Order",
        style: TextStyle(color: Colors.white),
      ),
          ),
        ],
      ),
    )
          ],
        ),
      ),
    ),
   
  ],
),
      );
  }
}
    


