
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grofix/repository/screens/bottomNav/bottomnavigation.dart';

class Otpscreen extends StatelessWidget{
  String verificationId;
  Otpscreen({super.key, required this.verificationId});
  @override
  Widget build (BuildContext context){
    TextEditingController OtpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("login your otp"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: OtpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.green,
                  )
                )
              ),
            ),
            SizedBox( height: 14,),
            ElevatedButton(onPressed: ()async{
              try{
                PhoneAuthCredential credential = 
                PhoneAuthProvider.credential(verificationId: verificationId, smsCode: OtpController.text.toString());
                FirebaseAuth.instance.signInWithCredential(credential).then((onValue){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottomnavigation()));
                }
                );
              }catch(ex){
               print(ex);

              }

            }, child: Text("login"))
          ],
        ),
      ),
    );
  }
}


