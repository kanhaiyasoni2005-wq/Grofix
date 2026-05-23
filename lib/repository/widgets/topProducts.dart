
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grofix/data/cartModel.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/buydierctory/buy_page.dart';
import 'package:provider/provider.dart';

class topProducts extends StatelessWidget {
  final List products;
  final String category;

  const topProducts({
    super.key,
    required this.products,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {

    // ✅ SAFE FILTER
    var filteredProducts = products.where((p) {
      try {
        return p.category?.toLowerCase() == category.toLowerCase();
      } catch (e) {
        return false; // 👈 agar category nahi hai to skip
      }
    }).toList();

    // ✅ Special case (Sell ke liye)
    if (category == "Sell") {
      filteredProducts = products.take(5).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            category,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // ✅ Agar empty ho to message show karo
        if (filteredProducts.isEmpty)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "No products available",
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {

                var p = filteredProducts[index];
                 return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return productOverView(product: p);
            }));
          },



                 

               child: Container(
                  width: 160,
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: p.image ?? "",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image_not_supported),
                        ),
                      ),
                      if (p.stock <= 0)
  Text(
    "Out of Stock",
    style: TextStyle(color: Colors.red, fontSize: 12),
  ),
                      Text(p.name ?? ""),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
              
                            Text(
                              "₹${p.price }",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
              
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: p.stock > 0
    ? () {
        var cartItem = CartModel(
          catagory: p.catagory!,
          Description: p.Description!,
          productId: p.id,
          name: p.name,
          image: p.image,
          price: p.price,
          quantity: 1,
        );

        var cart = context.read<Cartprovider>();
        cart.addItem(cartItem);
        cart.showCartPopupTemporarily();
      }
    : null, // ❌ disable when stock = 0
                                icon: Icon(Icons.add, color: p.stock > 0 ? Colors.white : Colors.green, size: 18),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                 );
              },
            ),
          ),
      ],
    );
  }
}


