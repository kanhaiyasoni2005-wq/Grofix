
import 'package:flutter/material.dart';
import 'package:grofix/repository/screens/bottomNav/bottomnavigation.dart';
import 'package:grofix/repository/screens/login/auth_service.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  body: SafeArea(
    child: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0f2027),
              Color(0xff203a43),
              Color(0xff2c5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "grofix",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),

              SizedBox(height: 6),

              Text(
                "Fast Grocery & Services",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 40),

              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    )
                  ],
                ),

                child: Column(
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/images/grofix.png",
                        height: 60,
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Login to continue",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 25),

                    // 🔥 SAME LOGIC
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 4,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        onPressed: () async {
                          var user = await signInWithGoogle(context);

                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Bottomnavigation(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login Failed")),
                            );
                          }
                        },
                        icon: Icon(Icons.login, color: Colors.red),
                        label: Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(
                      "Secure login powered by Google",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }
}


