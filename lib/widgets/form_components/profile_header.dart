import 'package:flutter/material.dart';
import '../../config/app_text.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppText.withColor(AppText.headlineLarge, Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppText.withColor(AppText.bodyLarge, Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
