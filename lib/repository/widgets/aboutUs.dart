import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Abaut_Us extends StatefulWidget {
  const Abaut_Us({super.key});

  @override
  State<Abaut_Us> createState() => _Abaut_UsState();
}

class _Abaut_UsState extends State<Abaut_Us> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("https://sites.google.com/view/grofix/home"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("About Us", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}


