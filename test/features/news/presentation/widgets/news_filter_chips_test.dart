import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/presentation/widgets/news_filter_chips.dart';

void main() {
  testWidgets('renders only All and Trend Related chips', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NewsFilterChips(
            selectedCategory: NewsCategory.all,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Trend Related'), findsOneWidget);
    expect(find.text('Sectors'), findsNothing);
    expect(find.text('Economy'), findsNothing);
    expect(find.byType(ChoiceChip), findsNWidgets(2));
  });
}
