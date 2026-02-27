import 'package:flutter/material.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/utils/theme_manager.dart';

class StocksScreen extends StatelessWidget {
  const StocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: PColor().primary,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => ThemeManager().toggleTheme(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('AAPL'),
              subtitle: const Text('Apple Inc.'),
              trailing: Text(
                isDark ? '+2.31%' : '+1.84%',
                style: TextStyle(
                  color: PColor().success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('TSLA'),
              subtitle: const Text('Tesla, Inc.'),
              trailing: Text(
                isDark ? '-1.11%' : '-0.72%',
                style: TextStyle(
                  color: PColor().danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search ticker...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Watchlist'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Buy Demo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
