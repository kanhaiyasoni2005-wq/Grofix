import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentDetail extends StatelessWidget {
  const DocumentDetail({super.key});

  Future<void> openWebsite() async {
    final Uri url =
        Uri.parse("https://sites.google.com/view/grofix/documents");

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openWebsite();
      Navigator.pop(context); // optional
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}