import 'package:flutter/material.dart';

import '../../../../core/assets.dart';

class SocialWidget extends StatelessWidget {
  const SocialWidget({super.key, required this.color, required this.image});

  factory SocialWidget.google() {
    return const SocialWidget(color: Colors.red, image: Assets.google);
  }

  factory SocialWidget.apple() {
    return const SocialWidget(color: Colors.black, image: Assets.apple);
  }

  factory SocialWidget.facebook() {
    return const SocialWidget(color: Colors.blue, image: Assets.facebook);
  }

  final Color color;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(child: Image.asset(image, height: 12, width: 12)),
    );
  }
}
