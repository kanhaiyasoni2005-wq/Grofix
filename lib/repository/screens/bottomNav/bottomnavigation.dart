
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grofix/repository/screens/Home/homepage.dart';
import 'package:grofix/repository/screens/Services/serviceui.dart';
import 'package:grofix/repository/screens/account/accountScreen.dart';
import 'package:grofix/repository/screens/cart/cartScreen.dart';
import 'package:grofix/repository/screens/cattegory/gridlayaut.dart';
class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {

   User? user = FirebaseAuth.instance.currentUser;
  int indexvalue = 0;
  List Page = [
   Homepage(),
    CategoryGrid(),
    cartScreen(),
    ServiceCatagory(),
    // accountPage(), 
  ];
  String  title(int index){
    switch(index){
      case 0: return "Home";
      case 1: return "Category";
      case 2: return "Cart";
      case 3: return "service";
      default: return "Home";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
  title: Text(title(indexvalue) , style: TextStyle(fontWeight: FontWeight.bold),),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => accountPage()));
        },
        child: SizedBox(
          height: 35,
          width: 35,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: user?.photoURL ?? "",

              fit: BoxFit.cover,

              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),

              errorWidget: (context, url, error) =>
                  Icon(Icons.person), // fallback icon
            ),
          ),
        ),
      ),
    ),
  ],
),
      
      
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 14,
        currentIndex: indexvalue,
        onTap: (int index){
          setState(() {
            
            indexvalue = index;
          });

        },
        items: [
        
        BottomNavigationBarItem(icon: SizedBox(width: 20, height: 20, child: Image.asset( "assets/images/home.png", width:10, height:10,)), label: "home"),
        BottomNavigationBarItem(icon: SizedBox(width: 20, height: 20, child: Image.asset( "assets/images/category.png", width:10, height:10,)), label: "category"),
        BottomNavigationBarItem(icon: SizedBox(width: 20, height: 20, child: Image.asset( "assets/images/grocery-store.png", width:10, height:10 )), label: "cart"),
        BottomNavigationBarItem(icon: SizedBox(width: 30, height: 30, child: Image.asset( "assets/images/service.png", width:10, height:10 )), label: "service"),
      ],
      type: BottomNavigationBarType.fixed,
   
    ),
    body: Page[indexvalue],
   
    );
  }
}


