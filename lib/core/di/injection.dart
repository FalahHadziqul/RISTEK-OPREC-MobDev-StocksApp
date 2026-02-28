import 'package:get_it/get_it.dart';
import 'package:mobile/core/di/core_locator.dart';
import 'package:mobile/features/news/di/news_locator.dart';
import 'package:mobile/features/profile/di/profile_locator.dart';
import 'package:mobile/features/stocks/di/stock_locator.dart';

/// Single GetIt instance shared across the entire app.
final sl = GetIt.instance;

/// Bootstraps all dependency injection.
///
/// Call order matters — core first, then features (which depend on core).
Future<void> initDependencies() async {
  // 1. Shared / cross-cutting
  setupCoreLocator(sl);

  // 2. Features (alphabetical — order doesn't matter between features)
  setupNewsLocator(sl);
  setupProfileLocator(sl);
  setupStockLocator(sl);
}
