import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/utils/external_link_launcher.dart';
import 'package:mobile/core/utils/url_launcher_external_link_launcher.dart';

/// Registers shared, cross-feature dependencies.
///
/// Must be called before any feature locator — features depend on these.
void setupCoreLocator(GetIt sl) {
  // ── External ──────────────────────────────────────────────────────────
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }

  // ── Shared services ───────────────────────────────────────────────────
  if (!sl.isRegistered<ExternalLinkLauncher>()) {
    sl.registerLazySingleton<ExternalLinkLauncher>(
      () => UrlLauncherExternalLinkLauncher(),
    );
  }
}
