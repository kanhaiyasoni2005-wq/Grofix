import 'package:flutter/material.dart';
import 'package:grofix/repository/screens/Services/servicepage.dart';
import 'package:grofix/repository/widgets/whatsap.dart';

class ServiceCatagory extends StatelessWidget {
  ServiceCatagory({super.key});

  final List<Map<String, String>> categories = [
    {
      "name": "AC Service",
      "image": "assets/images/service copy.png"
    },
    {
      "name": "Electric Service",
      "image": "assets/images/electrician.png"
    },
    {
      "name": "CSC Service",
      "image": "assets/images/b2c.png"
    },
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Services",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Screenshot जैसा
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            var cat = categories[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                String category = cat["name"]!;

                if (category.toLowerCase() == "csc service") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ServiceFormScreen(categoryName: category),
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Service Instruction"),
                    content: const Text(
                      "• Home visit charge ₹50 (if no work done)\n"
                      "• If work is done → no visit charge\n"
                      "• Service charge will apply based on work",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceFormScreen(
                                categoryName: category,
                              ),
                            ),
                          );
                        },
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
                );
              },

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Image
                    Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        cat["image"]!,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Name
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        cat["name"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
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
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: openWhatsApp,

  backgroundColor: Colors.green,

  child: const Icon(
    
    Icons.chat,
    color: Colors.white,
  ),
),
    );
  }
}