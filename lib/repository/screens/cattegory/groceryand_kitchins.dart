// import 'package:grofix/repository/widgets/uihelper.dart';
// import 'package:flutter/material.dart';
// class GroceryandKitchins extends StatelessWidget {
//   @override

//   List<Map<String, String>> fruits = [
//   {"name": "Apple", "desc": "A sweet and crunchy fruit."},
//   {"name": "Banana", "desc": "A soft fruit rich in energy."},
//   {"name": "Mango", "desc": "A juicy tropical fruit."},
//   {"name": "Grapes", "desc": "Small and juicy fruits."},
//   {"name": "Orange", "desc": "Rich in vitamin C."},
//   {"name": "Pineapple", "desc": "Sweet and tangy tropical fruit."},
//   {"name": "Strawberry", "desc": "Sweet and slightly sour fruit."},
//   {"name": "Watermelon", "desc": "Refreshing fruit with high water content."},
//   {"name": "Papaya", "desc": "Good for digestion."},
//   {"name": "Kiwi", "desc": "Tangy fruit with green flesh."},
// ];

 
//   String text;
//   Color color ; 
//   double size ;
//   String img;
  
  
//   GroceryandKitchins({super.key,  required this.text, this.color = Colors.black, this.size = 16.0, required this.img });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
    
//         child: Container(
          
//           child: GridView.extent(
            
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//             maxCrossAxisExtent: 150, 
//             childAspectRatio: 0.75,
//           children: [
         
          
//          Column(
//            children: [
//              Container(
                    
                    
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(1),
                      
                     
//                     ),
//                     child: Image.asset("assets/images/loginpage.jpeg",),
               
//                   ),
//                   Uihelper.customefont(text: "Fruits", color: Colors.black, size: 16, weight: FontWeight.bold,)
//            ],
//          ),
         
            
          
//          Column(
//            children: [
//              Container( 
//                      decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(1),
                      
                     
//                     ),child: Image.asset( "assets/images/loginpage.jpeg",),),
//                     Uihelper.customefont(text: "Vegetables", color: Colors.black, size: 16, weight: FontWeight.bold,)
//            ],
//          ),
            
//              Column(
//                children: [
//                  Container( 
//                    decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(1),
                    
                 
                   
//                   ),child: Image.asset( "assets/images/loginpage.jpeg",),
//                   ),
//                   Uihelper.customefont(text: "Dairy", color: Colors.black, size: 16, weight: FontWeight.bold,)
//                ],
//              ),
//             Column(
//               children: [
//                 Container( decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(1),
                    
                   
//                   ), child: Image.asset( "assets/images/loginpage.jpeg",),),
//                   Uihelper.customefont(text: "Atta", color: Colors.black, size: 20, weight: FontWeight.bold,)
//               ],
//             ),
//                Column(
//                  children: [
//                    Container( decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(1),
                    
                   
//                                ), child: Image.asset( "assets/images/loginpage.jpeg",),),
//                                Uihelper.customefont(text: "snacks ", color: Colors.black, size: 20, weight: FontWeight.bold,)
//                  ],
//                ),
               
//           ],)
          
//         ),
      
//     );
//   }
// }


