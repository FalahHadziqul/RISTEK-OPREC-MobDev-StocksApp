import 'package:mobile/core/utils/external_link_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherExternalLinkLauncher implements ExternalLinkLauncher {
  @override
  Future<bool> launch(String url) async {
    Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {
      return false;
    }

    final mode = uri.scheme == 'mailto'
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;

    return launchUrl(uri, mode: mode);
  }
}
