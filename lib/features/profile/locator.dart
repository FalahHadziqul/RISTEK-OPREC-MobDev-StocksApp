import 'package:mobile/core/utils/external_link_launcher.dart';
import 'package:mobile/core/utils/url_launcher_external_link_launcher.dart';
import 'package:mobile/features/profile/data/datasources/profile_social_local_data_source.dart';
import 'package:mobile/features/profile/presentation/cubit/profile_social_cubit.dart';

class ProfileLocator {
  static bool _isInitialized = false;

  static late final ProfileSocialLocalDataSource profileSocialLocalDataSource;
  static late final ExternalLinkLauncher externalLinkLauncher;

  static void setup() {
    if (_isInitialized) {
      return;
    }

    profileSocialLocalDataSource = ProfileSocialLocalDataSourceImpl();
    externalLinkLauncher = UrlLauncherExternalLinkLauncher();
    _isInitialized = true;
  }

  static ProfileSocialCubit createProfileSocialCubit() {
    return ProfileSocialCubit(
      localDataSource: profileSocialLocalDataSource,
      externalLinkLauncher: externalLinkLauncher,
    );
  }
}
