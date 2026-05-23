
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/Home/category_section.dart';
import 'package:grofix/repository/widgets/all_products_widget.dart';
import 'package:grofix/repository/widgets/popup.dart';
import 'package:grofix/repository/widgets/topProducts.dart';

import 'package:provider/provider.dart';



class Homepage extends StatefulWidget{
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
   @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<Viewmodel>(context, listen: false).fetchproduct();
      context.read<Cartprovider>().fetchCart();
       Provider.of<Viewmodel>(context, listen: false).fetchBanners(); 
    });}
  @override
  Widget build(BuildContext context) {  
    User? user = FirebaseAuth.instance.currentUser;
    var vm = Provider.of<Viewmodel>(context);


    return Scaffold(
      
      
     body:
     
          Stack(
            children: [
              ListView(
  children: [

    /// 🔥 TOP BANNER (अब scroll करेगा)
    Consumer<Viewmodel>(
  builder: (context, vm, child) {
    if (vm.bannerImages.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              viewportFraction: 1,
            ),
            items: vm.bannerImages.map((imageUrl) {
              return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
        ),
        placeholder: (context, url) =>
        Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) =>
        Icon(Icons.broken_image),
      );
              // return Image.network(
              //   imageUrl,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              // );
            }).toList(),
          ),
        ),
      ),
    );
  },
),

    SizedBox(height: 20),

    /// 🔥 CATEGORY
    CategorySection(category: "vegetables", vm: vm),
    CategorySection(category: "fruits", vm: vm),
    CategorySection(category: "dairy", vm: vm),
    CategorySection(category: "beverages", vm: vm),
 topProducts( products: vm.products, category: "Sell",),

    CategorySection(category: "snacks", vm: vm),
    CategorySection(category: "clothes", vm: vm),
    CategorySection(category: "hardware", vm: vm),
   
    /// 🔥 ALL PRODUCTS
    AllProductsGrid(products: vm.products),
  ],
),
          
                    
                    ViewCartPopup(),
                    
            ],
          )
                  
            
          
       
    );
}
}


