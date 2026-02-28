import 'package:get_it/get_it.dart';
import 'package:mobile/features/profile/data/datasources/profile_social_local_data_source.dart';
import 'package:mobile/features/profile/presentation/cubit/profile_social_cubit.dart';

/// Registers all Profile-feature dependencies.
///
/// Depends on [ExternalLinkLauncher] from core locator.
void setupProfileLocator(GetIt sl) {
  // ── Data sources ──────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileSocialLocalDataSource>(
    () => ProfileSocialLocalDataSourceImpl(),
  );

  // ── Cubits ────────────────────────────────────────────────────────────
  // Factory: new instance per screen / BlocProvider.
  sl.registerFactory(
    () => ProfileSocialCubit(localDataSource: sl(), externalLinkLauncher: sl()),
  );
}
