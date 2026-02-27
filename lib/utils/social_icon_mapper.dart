import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIconMapper {
  static Widget getIcon(BuildContext context, String iconKey) {
    final color = Theme.of(context).colorScheme.primary;

    switch (iconKey) {
      case 'github':
        return SvgPicture.asset(
          'assets/icons/github.svg',
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );

      case 'linkedin':
        return SvgPicture.asset(
          'assets/icons/linkedin.svg',
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );

      case 'email':
        return SvgPicture.asset(
          'assets/icons/gmail.svg',
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );

      default:
        return const Icon(Icons.link);
    }
  }
}
