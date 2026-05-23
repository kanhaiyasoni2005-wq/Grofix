
import 'package:flutter/material.dart';
import 'package:grofix/repository/screens/cattegory/categarypage.dart';

class CategoryGrid extends StatelessWidget {
  CategoryGrid({super.key});

  final List<Map<String, String>> categories = [
    {
      "name": "Vegetables",
      "image": "assets/images/vegetable.png"
    },
    {
      "name": "Fruits",
      "image": "assets/images/fruits.png"
    },
    {
      "name": "Snacks",
      "image": "assets/images/snack.png"
    },
    {
      "name": "Dairy",
      "image": "assets/images/dairy-products.png"
    },
    {
      "name": "beverages",
      "image": "assets/images/soft-drink.png"
    },
    // {
    //   "name": "Bakery",
    //   "image": "https://cdn-icons-png.flaticon.com/512/1046/1046786.png"
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        itemCount: categories.length,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 👈 columns
          crossAxisSpacing: 12,
          mainAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),

        itemBuilder: (context, index) {

          var cat = categories[index];

          return GestureDetector(
           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CategoryFilterScreen(
        selectedCategory: cat["name"]!,
      ),
    ),
  );
},

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  )
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // 🔥 IMAGE BOX
                  Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
  cat["image"]!,
  fit: BoxFit.contain,
),
                  ),

                  SizedBox(height: 10),

                  // 🔥 TEXT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      cat["name"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


