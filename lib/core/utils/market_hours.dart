class MarketHours {
  const MarketHours._();

  /// US market approximation (UTC):
  /// Open: 14:30 UTC, Close: 21:00 UTC, Monday-Friday.
  static bool isMarketOpen() {
    final now = DateTime.now().toUtc();

    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      return false;
    }

    final minutes = now.hour * 60 + now.minute;
    const openMinutes = 14 * 60 + 30;
    const closeMinutes = 21 * 60;

    return minutes >= openMinutes && minutes < closeMinutes;
  }

  /// Faster refresh while market is open, slower when closed.
  static Duration marketAwareTtl({
    Duration openTtl = const Duration(hours: 1),
    Duration closedTtl = const Duration(hours: 6),
  }) {
    return isMarketOpen() ? openTtl : closedTtl;
  }
}
