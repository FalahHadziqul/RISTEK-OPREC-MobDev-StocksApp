import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/core/themes/text_style_theme.dart';

class InterestSection extends StatelessWidget {
  const InterestSection({super.key});

  static const List<String> _interests = [
    'Mobile Dev',
    'Flutter',
    'Web Dev',
    'UI/UX',
    'Clean Architecture',
    'Chess',
    'Football',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = PColor();
    final style = Style();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests & Hobbies',
          style: style.bold.copyWith(
            fontSize: 16.sp,
            color: isDark ? color.textPrimaryDark : color.textPrimaryLight,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _interests.map((interest) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                interest,
                style: style.medium.copyWith(
                  fontSize: 12.sp,
                  color: color.primary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
