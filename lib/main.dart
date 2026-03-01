import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/features/stocks/data/datasources/stock_local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (error) {
    debugPrint('Unable to load .env: $error');
  }

  // Initialise Hive and open cache boxes before DI
  await Hive.initFlutter();
  await StockLocalDataSourceImpl.openBoxes();

  await initDependencies();

  runApp(const MyApp());
}
