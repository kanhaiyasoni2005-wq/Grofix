
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

   List filteredProducts;

if (category.trim().toLowerCase() == "sell") {
  filteredProducts = products.where((p) {
    return ((p.catagory ?? "")
            .trim()
            .toLowerCase()) ==
        "sell";
  }).toList();
} else {
  filteredProducts = products.where((p) {
    return ((p.catagory ?? "")
            .trim()
            .toLowerCase()) ==
        category.trim().toLowerCase();
  }).toList();
}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        if (filteredProducts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("No products available"),
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
                        builder: (_) =>
                            productOverView(product: p),
                      ),
                    );
                  },

                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(
                      left: 10,
                      bottom: 5,
                    ),

                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(14),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Expanded(
                          child: Container(
                            width: double.infinity,

                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,

                              borderRadius:
                                  BorderRadius.circular(12),
                            ),

                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(12),

                              child:
                                  CachedNetworkImage(
                                imageUrl:
                                    p.image ?? "",

                                fit:
                                    BoxFit.contain,

                                placeholder:
                                    (_, __) =>
                                        const Center(
                                  child:
                                      CircularProgressIndicator(),
                                ),

                                errorWidget:
                                    (_, __, ___) =>
                                        const Icon(
                                  Icons
                                      .image_not_supported,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        if ((p.stock ?? 0) <= 0)
                          const Text(
                            "Out of Stock",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          p.name ?? "",

                          maxLines: 1,

                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Text(
                              "₹${p.price}",

                              style:
                                  const TextStyle(
                                color:
                                    Colors.green,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Container(
                              height: 32,
                              width: 32,

                              decoration:
                                  BoxDecoration(
                                color:
                                    (p.stock ?? 0) >
                                            0
                                        ? Colors
                                            .green
                                        : Colors
                                            .grey,

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),
                              ),

                              child:
                                  IconButton(
                                padding:
                                    EdgeInsets
                                        .zero,

                                onPressed:
                                    (p.stock ??
                                                0) >
                                            0
                                        ? () {

                                            var cartItem =
                                                CartModel(
                                              catagory:
                                                  p.catagory ??
                                                      "",

                                              Description:
                                                  p.Description ??
                                                      "",

                                              productId:
                                                  p.id,

                                              name:
                                                  p.name,

                                              image:
                                                  p.image,

                                              price:
                                                  p.price,

                                              quantity:
                                                  1,
                                            );

                                            context
                                                .read<
                                                    Cartprovider>()
                                                .addItem(
                                                    cartItem);

                                            context
                                                .read<
                                                    Cartprovider>()
                                                .showCartPopupTemporarily();
                                          }
                                        : null,

                                icon:
                                    Icon(
                                  Icons.add,

                                  color:
                                      (p.stock ??
                                                  0) >
                                              0
                                          ? Colors
                                              .white
                                          : Colors
                                              .grey,
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
