import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveuserDetails({
  required String name,
  required String phoneno,
  required String adress,
}) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User is not logged in");
  }

  await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .collection("Address")
      .add({
    "name": name,
    "phone": phoneno,
    "Address": adress,
  });
}

