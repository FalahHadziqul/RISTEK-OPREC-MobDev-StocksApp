import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Notice we removed FlutterNativeSplash.preserve()
  // and FlutterNativeSplash.remove() entirely!
  // The package will now automatically dismiss the splash screen
  // the exact moment the runApp() draws its first frame.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ristek Stock',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TemporaryFlutterDemoPage(),
    );
  }
}

class TemporaryFlutterDemoPage extends StatefulWidget {
  const TemporaryFlutterDemoPage({super.key});

  @override
  State<TemporaryFlutterDemoPage> createState() =>
      _TemporaryFlutterDemoPageState();
}

class _TemporaryFlutterDemoPageState extends State<TemporaryFlutterDemoPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo (Temporary)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
