import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:mobile/core/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupAppLocator();

  runApp(const MyApp());
}
