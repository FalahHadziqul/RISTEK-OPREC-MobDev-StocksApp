import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/core/themes/text_style_theme.dart';
import 'package:mobile/utils/theme_manager.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = PColor();
    final style = Style();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearance',
          style: style.bold.copyWith(
            fontSize: 16.sp,
            color: isDark ? color.textPrimaryDark : color.textPrimaryLight,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isDark ? color.containerDark : color.containerLight,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: color.primary,
                size: 22.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dark Mode',
                      style: style.semiBold.copyWith(
                        fontSize: 14.sp,
                        color: isDark
                            ? color.textPrimaryDark
                            : color.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isDark ? 'Currently active' : 'Tap to enable',
                      style: style.regular.copyWith(
                        fontSize: 12.sp,
                        color: isDark
                            ? color.textSecondaryDark
                            : color.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                activeThumbColor: color.primary,
                onChanged: (_) => ThemeManager().toggleTheme(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
