
import 'package:flutter/material.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/data/cartModel.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/buydierctory/buy_page.dart';
import 'package:grofix/repository/screens/cattegory/categarypage.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CategorySection extends StatelessWidget {
  final String category;
  final Viewmodel vm;

  const CategorySection({
    super.key,
    required this.category,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {

    var filteredProducts = vm.products.where((p) {
  return (p.catagory )
          .trim()
          .toLowerCase() ==
      category
          .trim()
          .toLowerCase();
}).toList();

    if (filteredProducts.isEmpty) return SizedBox();

    return  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    /// TITLE
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        category,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),

    /// GRID
    GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredProducts.length > 6 ? 6 : filteredProducts.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),

      itemBuilder: (context, index) {

        var p = filteredProducts[index];

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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: p.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => SizedBox(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    ),
                  ),
                ),
                if (p.stock <= 0)
  Text(
    "Out of Stock",
    style: TextStyle(color: Colors.red, fontSize: 12),
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
          catagory: p.catagory,
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
              ],
            ),
          ),
        );
      },
    ),

    /// ✅ SEE ALL BUTTON (yahi hona chahiye)
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
  onTap: () {
      Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CategoryFilterScreen(
        selectedCategory: category,
      ),
    ),
  );
    // TODO: navigate to full category page
  },
  child: Text(
    "See All",
    style: TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w600,
    ),
  ),
)
      ),
    ),

  ],
);
  }
}


