import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/features/profile/locator.dart';
import 'package:mobile/features/profile/presentation/cubit/profile_social_cubit.dart';
import 'package:mobile/features/profile/presentation/widgets/appearance_section.dart';
import 'package:mobile/features/profile/presentation/widgets/intereset_section.dart';
import 'package:mobile/features/profile/presentation/widgets/profile_header.dart';
import 'package:mobile/features/profile/presentation/widgets/social_tile.dart';
import 'package:mobile/utils/social_icon_mapper.dart';
import 'package:mobile/utils/theme_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileLocator.createProfileSocialCubit()..loadSocialLinks(),
      child: BlocConsumer<ProfileSocialCubit, ProfileSocialState>(
        listener: (context, state) {
          final message = state.errorMessage;
          if (message == null) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));

          context.read<ProfileSocialCubit>().clearErrorMessage();
        },
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final color = PColor();

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('About Me'),
              actions: [
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: color.primary,
                  ),
                  tooltip: isDark
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                  onPressed: () => ThemeManager().toggleTheme(),
                ),
              ],
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                const ProfileHeader(),
                SizedBox(height: 24.h),
                Divider(
                  color: isDark
                      ? color.divider
                      : color.textSecondaryLight.withValues(alpha: 0.2),
                ),
                SizedBox(height: 16.h),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ...state.socialLinks.map(
                    (link) => SocialTile(
                      icon: SocialIconMapper.getIcon(context, link.iconKey),
                      label: link.label,
                      value: link.displayText,
                      onTap: () {
                        context.read<ProfileSocialCubit>().onSocialTapped(link);
                      },
                    ),
                  ),
                SizedBox(height: 24.h),
                const AppearanceSection(),
                SizedBox(height: 24.h),
                const InterestSection(),
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
