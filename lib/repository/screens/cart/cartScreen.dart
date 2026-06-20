
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/bottomNav/bottomnavigation.dart';
import 'package:grofix/repository/screens/cart/revewpage.dart';
import 'package:provider/provider.dart';
class cartScreen extends StatefulWidget {
  const cartScreen({super.key});

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Cartprovider>().fetchCart();
  }
  
  
  var cart = 1;


 @override
Widget build(BuildContext context) {
  final cartProvider = context.watch<Cartprovider>();

  return Scaffold(
    
    
    

    body: cartProvider.cartList.isEmpty
        ? Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Bottomnavigation(),
                  ),
                );
              },
              child: Text(
                "Start Shopping",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 20),
            child: Column(
              children: [
                Expanded(
  child: ListView.builder(
    padding: EdgeInsets.only(bottom: 10),
    itemCount: cartProvider.cartList.length,
    itemBuilder: (context, index) {
      final item = cartProvider.cartList[index];

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [

            // ================= IMAGE =================
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 65,
                height: 65,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) =>
                    Icon(Icons.broken_image),
              ),
            ),

            SizedBox(width: 10),

            // ================= DETAILS =================
            Expanded(
  child: StreamBuilder<DocumentSnapshot>(

    stream: FirebaseFirestore.instance
        .collection("User")
        .doc(item.productId)
        .snapshots(),

    builder: (context, snapshot) {

      if (!snapshot.hasData) {
        return SizedBox();
      }

      final product =
          snapshot.data!.data()
          as Map<String, dynamic>;

      double price =
          (product["price"] ?? 0)
          .toDouble();

      return Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            item.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "₹$price",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Total: ₹${price * item.quantity}",
            style: TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      );
    },
  ),
),

            // ================= ACTIONS =================
            Column(
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [

                      IconButton(
                        icon: Icon(Icons.remove, size: 18),
                        onPressed: () {
                          context.read<Cartprovider>().decreaseItem(item);
                        },
                      ),

                      Text("${item.quantity}"),

                      IconButton(
                        icon: Icon(Icons.add, size: 18),
                        onPressed: () {
                          context.read<Cartprovider>().increaseItem(item);
                        },
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 18),
                  onPressed: () {
                    context.read<Cartprovider>().removeItem(item.productId);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  ),
),

                Container(
  margin: EdgeInsets.all(10),
  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
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
            "₹${cartProvider.totalPrice.toStringAsFixed(2)}",
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
        onPressed: () {
          if(cartProvider.totalPrice >= 100){
             Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => productReview()),
          );
          
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("The minimum order amount should be 100 rupees" ,style: TextStyle(color: Colors.grey.shade300),),
              backgroundColor: Colors.black87,
              )
            );
          }
         
        },
        child: Text(
          "Checkout",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  ),
)
              ],
            ),
          ),
  );
}}


