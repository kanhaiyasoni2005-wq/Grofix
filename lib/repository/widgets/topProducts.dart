
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
        return false;
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ✅ Empty state
        if (filteredProducts.isEmpty)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "No products available",
              style: TextStyle(
                color: Color.fromARGB(255, 22, 22, 22),
              ),
            ),
          )
        else
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                var p = filteredProducts[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return productOverView(product: p);
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.only(left: 10, bottom: 5),
                    padding: EdgeInsets.all(8),

                    // ✅ CARD DESIGN
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ✅ IMAGE WITH BACKGROUND
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: p.image ?? "",
                                fit: BoxFit.contain,

                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),

                                errorWidget: (context, url, error) =>
                                    Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        // ✅ STOCK
                        if (p.stock <= 0)
                          Text(
                            "Out of Stock",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        SizedBox(height: 4),

                        // ✅ PRODUCT NAME
                        Text(
                          p.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),

                        SizedBox(height: 6),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            // ✅ PRICE
                            Text(
                              "₹${p.price}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ✅ ADD BUTTON
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: p.stock > 0
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                borderRadius:
                                    BorderRadius.circular(8),
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

                                        var cart =
                                            context.read<Cartprovider>();

                                        cart.addItem(cartItem);
                                        cart.showCartPopupTemporarily();
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.add,
                                  color: p.stock > 0
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 18,
                                ),
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
