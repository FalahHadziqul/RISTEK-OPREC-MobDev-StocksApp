import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/domain/utils/news_topic_mapper.dart';

void main() {
  group('NewsTopicMapper', () {
    test('normalizes topic by trimming and lowercasing', () {
      expect(
        NewsTopicMapper.normalizeTopic(' Economy - Monetary '),
        'economy_monetary',
      );
    });

    test('maps finance topic to sectors', () {
      final categories = NewsTopicMapper.mapTopicsToCategories(['finance']);
      expect(categories, {NewsCategory.sectors});
    });

    test('maps economy - macro to economy', () {
      final categories = NewsTopicMapper.mapTopicsToCategories(['economy_macro']);
      expect(categories, {NewsCategory.economy});
    });

    test('maps multiple categories from topics', () {
      final categories = NewsTopicMapper.mapTopicsToCategories([
        'technology',
        'economy_macro',
      ]);
      expect(categories, {NewsCategory.sectors, NewsCategory.economy});
    });

    test('maps sector topics to sectors', () {
      final categories = NewsTopicMapper.mapTopicsToCategories([
        'real_estate',
      ]);
      expect(categories, {NewsCategory.sectors});
    });

    test('ignores unknown topics', () {
      final categories = NewsTopicMapper.mapTopicsToCategories(['sports']);
      expect(categories, isEmpty);
    });
  });
}

