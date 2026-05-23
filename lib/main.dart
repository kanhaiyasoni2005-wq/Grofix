
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/splash/splashscreen.dart';


import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cartprovider()),
        ChangeNotifierProvider(create: (_) => Viewmodel())
      ],
      child: MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grofix',
      theme: ThemeData(
     
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 160, 183, 58)),
      ),
      home: 
      
      splashScreen()
      //  showData()
      // 
    );
  }
}

 

