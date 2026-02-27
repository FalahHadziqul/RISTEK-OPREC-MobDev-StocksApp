import 'package:mobile/features/profile/domain/entities/social_link.dart';

abstract class ProfileSocialLocalDataSource {
  List<SocialLink> getSocialLinks();
}

class ProfileSocialLocalDataSourceImpl implements ProfileSocialLocalDataSource {
  @override
  List<SocialLink> getSocialLinks() {
    return const [
      SocialLink(
        id: 'email',
        label: 'Email',
        displayText: 'hadziqulfalah18@gmail.com',
        launchUrl: 'mailto:hadziqulfalah18@gmail.com',
        iconKey: 'email',
      ),
      SocialLink(
        id: 'github',
        label: 'GitHub',
        displayText: 'FalahHadziqul',
        launchUrl: 'https://github.com/FalahHadziqul',
        iconKey: 'github',
      ),
      SocialLink(
        id: 'linkedin',
        label: 'LinkedIn',
        displayText: 'Muhammad Hadziqul Falah T.',
        launchUrl:
            'https://www.linkedin.com/in/muhammad-hadziqul-falah-teguh-544bba320/',
        iconKey: 'linkedin',
      ),
    ];
  }
}
