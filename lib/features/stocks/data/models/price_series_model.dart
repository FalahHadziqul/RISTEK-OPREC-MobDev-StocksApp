import '../../domain/entities/price_series.dart';

class PricePointModel extends PricePoint {
  const PricePointModel({
    required super.date,
    required super.open,
    required super.high,
    required super.low,
    required super.close,
    required super.volume,
  });

  /// Parse a single daily entry from the TIME_SERIES_DAILY response.
  /// [dateStr] is the map key (e.g. "2026-02-27").
  factory PricePointModel.fromJson(String dateStr, Map<String, dynamic> json) {
    return PricePointModel(
      date: DateTime.parse(dateStr),
      open: double.tryParse(json['1. open'] ?? '') ?? 0,
      high: double.tryParse(json['2. high'] ?? '') ?? 0,
      low: double.tryParse(json['3. low'] ?? '') ?? 0,
      close: double.tryParse(json['4. close'] ?? '') ?? 0,
      volume: int.tryParse(json['5. volume'] ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      '1. open': open.toString(),
      '2. high': high.toString(),
      '3. low': low.toString(),
      '4. close': close.toString(),
      '5. volume': volume.toString(),
    };
  }
}

class PriceSeriesModel extends PriceSeries {
  const PriceSeriesModel({required super.symbol, required super.points});

  /// Parse the full TIME_SERIES_DAILY JSON response.
  factory PriceSeriesModel.fromJson(Map<String, dynamic> json) {
    final symbol =
        (json['Meta Data'] as Map<String, dynamic>?)?['2. Symbol'] ?? '';
    final timeSeries =
        (json['Time Series (Daily)'] as Map<String, dynamic>?) ?? {};

    final points =
        timeSeries.entries
            .map(
              (e) => PricePointModel.fromJson(
                e.key,
                e.value as Map<String, dynamic>,
              ),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date)); // newest first

    return PriceSeriesModel(symbol: symbol, points: points);
  }

  /// Serialize to JSON for Hive caching.
  Map<String, dynamic> toJson() {
    return {
      'Meta Data': {'2. Symbol': symbol},
      'Time Series (Daily)': {
        for (final p in points.cast<PricePointModel>())
          p.date.toIso8601String().substring(0, 10): {
            '1. open': p.open.toString(),
            '2. high': p.high.toString(),
            '3. low': p.low.toString(),
            '4. close': p.close.toString(),
            '5. volume': p.volume.toString(),
          },
      },
    };
  }
}
