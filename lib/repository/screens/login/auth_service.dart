
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> signInWithGoogle(BuildContext context) async {
  String webclientId = "717672718438-srthje0ddnb26rvvcjiiai8mmrm9dl0r.apps.googleusercontent.com";
  try {
    // Google sign in trigger
    GoogleSignIn signIn = GoogleSignIn.instance;
    await signIn.initialize(serverClientId:webclientId );
    GoogleSignInAccount?  account = await signIn.authenticate();
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignInAuthentication googleAuth = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      
    );

    final userCreadential = await auth.signInWithCredential(credential);
    //  final User? user = user_creadential.user;

    
    final user = userCreadential.user;
    await saveUserToFirestore(user!).then((_){
print("user saved succesfuly");
    }).catchError((e){
    print("Firestore Error: $e");
    });

    
    
return user;

  } catch (e) {
    print("Google Sign-In Error: $e");
    return null;
  }

}
  Future<void> saveUserToFirestore(User user) async {
  final userRef = FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid);

  final doc = await userRef.get();

  // 👉 अगर user पहले से नहीं है
  if (!doc.exists) {
    await userRef.set({
      "uid": user.uid,
      "name": user.displayName,
      "email": user.email,
      "image": user.photoURL,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
 

