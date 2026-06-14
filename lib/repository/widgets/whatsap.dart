
import 'package:url_launcher/url_launcher.dart';
Future<void> openWhatsApp() async {
  final Uri url = Uri.parse(
    "https://wa.me/7898116378"
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}