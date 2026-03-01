import 'package:mobile/features/news/domain/entities/news.dart';

class NewsTopicMapper {
  static const Set<String> _economyTopics = {
    'economy_monetary',
    'economy_macro',
  };

  static const Set<String> _sectorsTopics = {
    'finance',
    'financial_markets',
    'earnings',
    'mergers_and_acquisitions',
    'ipo',
    'technology',
    'manufacturing',
    'life_sciences',
    'real_estate',
    'real_estate_construction',
    'retail_wholesale',
    'energy_transportation',
  };

  static String normalizeTopic(String raw) {
    final lowered = raw.trim().toLowerCase();
    final canonical = lowered.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return canonical
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  static Set<NewsCategory> mapTopicsToCategories(Iterable<String> topics) {
    final categories = <NewsCategory>{};

    for (final raw in topics) {
      final topic = normalizeTopic(raw);
      if (_economyTopics.contains(topic) || topic.startsWith('economy_')) {
        categories.add(NewsCategory.economy);
      }

      if (_sectorsTopics.contains(topic)) {
        categories.add(NewsCategory.sectors);
      }
    }

    return categories;
  }
}
