import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Uihelper {

  static Widget customImage({
    required String image_url,
    double height = 24,
    double width = 24,
    BoxFit fit = BoxFit.cover,
  }) {

    final trimmedUrl = image_url.trim();

    // 🔹 Empty URL → default image
    if (trimmedUrl.isEmpty) {
      return Image.asset(
        'assets/images/user.png',
        fit: fit,
        width: width,
        height: height,
      );
    }

    final uri = Uri.tryParse(trimmedUrl);

    // 🔹 Network Image
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return CachedNetworkImage(
        imageUrl: trimmedUrl,
        fit: fit,
        width: width,
        height: height,

        // loading
        placeholder: (context, url) => SizedBox(
          height: height,
          width: width,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),

        // error fallback
        errorWidget: (context, url, error) {
          return Image.asset(
            'assets/images/user.png',
            fit: fit,
            width: width,
            height: height,
          );
        },
      );
    }

    // 🔹 Local asset
    return Image.asset(
      trimmedUrl,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Text customefont({
    required String text,
    Color color = Colors.black,
    double size = 16,
    FontWeight weight = FontWeight.normal,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}

