
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grofix/data/cartModel.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/buydierctory/buy_page.dart';
import 'package:provider/provider.dart';

class AllProductsGrid extends StatelessWidget {
  final List products;

  const AllProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "All Products",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // important
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75, // size adjust
          ),
          itemBuilder: (context, index) {

            var p = products[index];
             return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return productOverView(product: p);
            }));
          },

             child: Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        blurRadius: 4,
        color: Colors.grey.shade300,
      )
    ],
  ),

  child: Column(
    children: [

      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: p.image,
            fit: BoxFit.contain,
            width: double.infinity,
            placeholder: (context, url) => SizedBox(),
            errorWidget: (context, url, error) =>
                Icon(Icons.broken_image),
          ),
        ),
      ),

      if (p.stock <= 0)
        Text(
          "Out of Stock",
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),

      Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Text(
              p.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${p.price}",
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
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: p.stock > 0
                        ? () {
                            var cartItem = CartModel(
                              catagory: p.catagory!,
                              Description:
                                  p.Description!,
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
                          : Colors.green,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
)
             );
          },
        ),
      ],
    );
  }
}


