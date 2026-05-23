// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Firebase extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("firebase"),
        
//       ),
//       body: Center(),
//     );


//   }
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List datalist = [];
//   Map<String , dynamic> newData = {
//     "name": "kanhaiya soni",
// "email": "kanhaiys onie ji"
//   };
//   Future<void> getDb() async{
//     var snap = await FirebaseFirestore.instance.collection("User").get();
//     // datalist =  snap.docs;
//     log("${snap.docs}");
//   }
//   addData(){
//     _firestore.collection("User").add(newData);
//   }
//   adddoc(){
//  _firestore.collection("user").doc("your id here").set(newData);

//   }
//   updateData()async{
//     await _firestore.collection("user").doc("your id here").update({
//       "email": "kanhaiya soni"
//     });
//   }
//   deletData()async{
// await _firestore.collection("user").doc("your id here").delete();
//   }
//   adddataall()async{
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("user").get();
//     log(snapshot.docs.toString());
//     // isme documents ki id aayengi

//   }
//   dddataall()async{
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("user").get();
//     for (var doc in snapshot.docs){
//       log(doc.data().toString());
//     }
    
   
    
//   }
 
// }

