import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/config/theme_config.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/theme_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeManager().themeMode,
          builder: (context, themeMode, _) {
            return MaterialApp.router(
              title: 'Ristek Stock',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: Routes.routerConfig,
            );
          },
        );
      },
    );
  }
}
