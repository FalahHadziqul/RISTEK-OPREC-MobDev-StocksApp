import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/core/themes/text_style_theme.dart';

class SocialTile extends StatelessWidget {
  const SocialTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = PColor();
    final style = Style();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(child: icon),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: style.medium.copyWith(
                      fontSize: 13.sp,
                      color: isDark
                          ? color.textSecondaryDark
                          : color.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: style.semiBold.copyWith(
                      fontSize: 14.sp,
                      color: isDark
                          ? color.textPrimaryDark
                          : color.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? color.textSecondaryDark
                  : color.textSecondaryLight,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
