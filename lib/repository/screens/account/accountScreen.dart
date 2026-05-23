
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grofix/orders/orders.dart';
import 'package:grofix/repository/screens/login/loginscreen.dart';
import 'package:grofix/repository/screens/privacypolycy/webpageprivacy.dart';
import 'package:grofix/repository/widgets/userdata.dart';

class accountPage extends StatelessWidget {
  const accountPage({super.key});

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text("My Account",style: TextStyle( fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [

          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [

                // PROFILE IMAGE
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user?.photoURL ?? "",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // NAME
                Text(
                  user?.displayName ?? "Guest User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  user?.email ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // ================= MENU =================
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [

                _buildCard(
                  icon: Icons.shopping_bag_outlined,
                  title: "My Orders",
                  subtitle: "Track your orders",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrderScreen()),
                    );
                  },
                ),

                _buildCard(
                  icon: Icons.location_on_outlined,
                  title: "My Address",
                  subtitle: "Manage delivery locations",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => userProfile()),
                    );
                  },
                ),



                _buildCard(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  subtitle: "View our privacy policy",
                  color: Colors.blue,
                  onTap: () async {
                  

                   Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(),
      ),
    );
                  },
                ),

                _buildCard(
  icon: Icons.logout,
  title: "Logout",
  subtitle: "Sign out from account",
  color: Colors.red,
  onTap: () async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Loginscreen()),
      (route) => false, // ye sab purane routes delete kar dega
    );
  },
),

                 

              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= CUSTOM CARD =================
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(subtitle),

        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}


