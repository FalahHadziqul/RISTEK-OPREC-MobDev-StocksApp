import 'package:flutter/material.dart';
import 'package:mobile/features/news/domain/entities/news.dart';

class NewsFilterChips extends StatelessWidget {
  final NewsCategory selectedCategory;
  final ValueChanged<NewsCategory> onSelected;

  const NewsFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  static const List<NewsCategory> _categories = [
    NewsCategory.all,
    NewsCategory.watchlist,
    NewsCategory.crypto,
    NewsCategory.forex,
    NewsCategory.stocks,
    NewsCategory.economy,
  ];

  String _label(NewsCategory category) {
    switch (category) {
      case NewsCategory.all:
        return 'All';
      case NewsCategory.watchlist:
        return 'Watchlist';
      case NewsCategory.crypto:
        return 'Crypto';
      case NewsCategory.forex:
        return 'Forex';
      case NewsCategory.stocks:
        return 'Stocks';
      case NewsCategory.economy:
        return 'Economy';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_label(category)),
              selected: isSelected,
              onSelected: (_) => onSelected(category),
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: colorScheme.surfaceContainer,
              selectedColor: colorScheme.primary,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }
}
