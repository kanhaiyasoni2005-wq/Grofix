

import 'package:flutter/material.dart';
import 'package:grofix/repository/screens/Services/servicepage.dart';

class ServiceCatagory extends StatelessWidget {
  ServiceCatagory({super.key});

 final List<Map<String, String>> categories = [
  {
    "name": "AC Service",
    "image": "assets/images/service copy.png"
  },
  {
    "name": "Electrician",
    "image":  "assets/images/electrician.png"
  },

  {
    "name": "CSC Service",
    "image": "assets/images/b2c.png"
  },
  
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  body: GridView.builder(
    padding: EdgeInsets.all(12),
    itemCount: categories.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 15,
      childAspectRatio: 0.75,
    ),
    itemBuilder: (context, index) {
      var cat = categories[index];

      return GestureDetector(
        onTap: () {
          String category = cat["name"]!;

          if (category.toLowerCase() == "csc service") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ServiceFormScreen(categoryName: category),
              ),
            );
            return;
          }

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Service Instruction"),
              content: Text(
                "• Home visit charge ₹50 (if no work done)\n"
                "• If work is done → no visit charge\n"
                "• Service charge will apply based on work",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceFormScreen(categoryName: category),
                      ),
                    );
                  },
                  child: Text("Continue"),
                ),
              ],
            ),
          );
        },

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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


