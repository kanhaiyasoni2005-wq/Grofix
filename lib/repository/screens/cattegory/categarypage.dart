// ab mujhe kisi item par click karne par mujhe ye screen chahiye or catagary specific agar vegitables par click kiya ho to vegitable show ho is screen me 

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/data/cartModel.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/widgets/popup.dart';
import 'package:provider/provider.dart';

class CategoryFilterScreen extends StatefulWidget {
 
  final String selectedCategory;

  const CategoryFilterScreen({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<CategoryFilterScreen> createState() =>
      _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen> {

 late String selectedCategory;

@override
void initState() {
  super.initState();
  selectedCategory = widget.selectedCategory.toLowerCase().trim();
}
  List<String> categories = [
    
    "vegetables",
    "fruits",
    "snacks",
    "dairy",
    "hardware"
    "electronics"
    "clothes"
    "beverages"
    "top Items"
  ];

  @override
  Widget build(BuildContext context) {

    var allProducts = context.watch<Viewmodel>().products;

    // 🔥 SAFE FILTER LOGIC
   var filteredProducts = allProducts.where((p) {

  String productCategory =
      (p.catagory ).toString().trim().toLowerCase();

  return productCategory == selectedCategory;

}).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Products"),
      ),

      body: Stack(
        children: [
          Column(
            children: [
          
              // ================= CATEGORY FILTER =================
           
          
              SizedBox(height: 10),
          
              // ================= PRODUCTS GRID =================
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          "No Products Found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
          
                          var product = filteredProducts[index];
          
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
          
                                // IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                imageUrl: product.image,
              height: 110,
              width: double.infinity,
                fit: BoxFit.cover,
              
                placeholder: (context, url) => SizedBox(),
                  
                errorWidget: (context, url, error) => 
                    Icon(Icons.broken_image),
              ),
                                  
                                ),
          
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
          
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
          
                                      SizedBox(height: 5),
                                    Text(
  product.Description ?? "",
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontSize: 12),
),
          
                                      Text("₹${product.price}"),
          
                                      SizedBox(height: 8),
          
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
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
      }
    : null, // ❌ disable when stock = 0
                                          child: Text("Add", style: TextStyle(color: product.stock > 0 ? Colors.white : Colors.green, fontSize: 18)),
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
              ),
            ],
          ),
          ViewCartPopup(),
        ],
      ),
    );
  }
}


