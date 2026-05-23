
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grofix/data/cartModel.dart';
import 'package:grofix/data/model.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:provider/provider.dart';

class productOverView extends StatelessWidget{
   final Product product;
    const productOverView({super.key, required this.product});
  @override
  Widget build (BuildContext context){
    
    
    return Scaffold(
appBar: AppBar(
  
  title: Text("Welcome"),
  
  
),
body: 
 Stack(
  children: [
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

      
          /// 🔥 PRODUCT IMAGE
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.broken_image),
              ),
            ),
          ),
      
          SizedBox(height: 15),
      
          /// 🔥 DETAILS SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
      
                /// NAME
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      
                SizedBox(height: 8),
      
                /// DESCRIPTION
                Text(
                  product.Description ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
      
                SizedBox(height: 15),
      
                /// PRICE + TAG
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
      
                    Text(
                      "₹${product.price}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
      
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: product.stock > 0
                        ? Text(
                          "In Stock",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        : Text(
                          "Out of Stock",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    )
                  ],
                ),
      
                SizedBox(height: 150), // 🔥 space for button
              ],
            ),
          ),
        ],
      ),
    ),

    /// 🔥 ADD TO CART BUTTON (BOTTOM FIXED)
    Positioned(
      bottom: 1,
      left: 15,
      right: 15,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
       onPressed: product.stock > 0
    ? () {
        var cartItem = CartModel(
          catagory: product.catagory,
          Description: product.Description!,
          productId: product.id,
          name: product.name,
          image: product.image,
          price: product.price,
          quantity: 1,
        );

        var cart = context.read<Cartprovider>();
        cart.addItem(cartItem);
        cart.showCartPopupTemporarily();

        // 🔥 ADD THIS MESSAGE
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text("${product.name} added to cart"),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }
    : null, // ❌ disable when stock = 0
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Add to Cart",
              style: TextStyle(
                fontSize: 16,
               color: product.stock > 0 ? Colors.white : Colors.green, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
    /// 🔥 POPUP (reuse)
   
      
    
    
    
  ],
),

    );
  }
}


