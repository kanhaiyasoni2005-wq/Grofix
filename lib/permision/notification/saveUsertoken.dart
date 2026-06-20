import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveUserToken() async {

 String uid =
 FirebaseAuth.instance.currentUser!.uid;

 String? token =
 await FirebaseMessaging.instance.getToken();

 if(token!=null){

 await FirebaseFirestore.instance
     .collection("users")
     .doc(uid)
     .set({
       "fcmToken": token,
     }, SetOptions(merge:true));

 }

}