import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/core/themes/text_style_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = PColor();
    final style = Style();

    return Column(
      children: [
        CircleAvatar(
          radius: 48.r,
          backgroundImage: const AssetImage('assets/images/hadziqulfalah.png'),
        ),
        SizedBox(height: 12.h),
        Text(
          'Hadziqul Falah',
          style: style.bold.copyWith(
            fontSize: 20.sp,
            color: isDark ? color.textPrimaryDark : color.textPrimaryLight,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Full-Time Leaner',
          style: style.regular.copyWith(
            fontSize: 13.sp,
            color: isDark ? color.textSecondaryDark : color.textSecondaryLight,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Building thoughtful apps with passion!',
          style: style.light.copyWith(
            fontSize: 11.sp,
            color: isDark ? color.textSecondaryDark : color.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
