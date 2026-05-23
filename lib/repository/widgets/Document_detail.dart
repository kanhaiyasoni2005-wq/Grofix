import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Document_detail extends StatefulWidget {
  const Document_detail({super.key});

  @override
  State<Document_detail> createState() => _Document_detailState();
}

class _Document_detailState extends State<Document_detail> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("https://sites.google.com/view/grofix/documents"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Document Details")
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}


