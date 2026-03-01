import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/features/stocks/domain/entities/company_overview.dart';
import 'package:mobile/features/stocks/domain/entities/price_series.dart';
import '../cubit/stock_detail_cubit.dart';

class StockDetailScreen extends StatelessWidget {
  final String symbol;

  const StockDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<StockDetailCubit>()..loadStockDetail(symbol),
      child: Scaffold(
        appBar: AppBar(title: Text(symbol)),
        body: BlocBuilder<StockDetailCubit, StockDetailState>(
          builder: (context, state) {
            if (state is StockDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              );
            } else if (state is StockDetailLoaded) {
              final overview = state.detail.overview;
              final priceSeries = state.detail.priceSeries;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _CompanyHeader(overview: overview, theme: theme),
                  const SizedBox(height: 16),
                  _DescriptionCard(
                    description: overview.description,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _MetricsGrid(overview: overview, theme: theme),
                  const SizedBox(height: 24),
                  _PriceHistory(points: priceSeries.points, theme: theme),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Company header ──────────────────────────────────────────────────────

class _CompanyHeader extends StatelessWidget {
  final CompanyOverview overview;
  final ThemeData theme;

  const _CompanyHeader({required this.overview, required this.theme});

  @override
  Widget build(BuildContext context) {
    final title = overview.name.isNotEmpty ? overview.name : overview.symbol;
    final exchange = overview.exchange.isNotEmpty ? overview.exchange : 'N/A';
    final sector = overview.sector.isNotEmpty ? overview.sector : 'N/A';
    final secondaryTextColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.72,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$exchange  •  $sector',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }
}

// ── Description ─────────────────────────────────────────────────────────

class _DescriptionCard extends StatelessWidget {
  final String description;
  final ThemeData theme;

  const _DescriptionCard({required this.description, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) return const SizedBox.shrink();
    final borderColor = theme.colorScheme.onSurface.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.16 : 0.08,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        description,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ── Key metrics grid ────────────────────────────────────────────────────

class _MetricsGrid extends StatelessWidget {
  final CompanyOverview overview;
  final ThemeData theme;

  const _MetricsGrid({required this.overview, required this.theme});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _Metric('Market Cap', _formatMarketCap(overview.marketCap)),
      _Metric('P/E Ratio', overview.peRatio),
      _Metric('EPS', overview.eps),
      _Metric('Dividend Yield', _formatPercent(overview.dividendYield)),
      _Metric('52-Week High', '\$${overview.high52Week}'),
      _Metric('52-Week Low', '\$${overview.low52Week}'),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: metrics
          .map((m) => _MetricChip(metric: m, theme: theme))
          .toList(),
    );
  }

  String _formatMarketCap(String raw) {
    final value = double.tryParse(raw);
    if (value == null) return raw;
    if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(2)}T';
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(2)}M';
    return '\$$raw';
  }

  String _formatPercent(String raw) {
    final value = double.tryParse(raw);
    if (value == null) return raw;
    return '${(value * 100).toStringAsFixed(2)}%';
  }
}

class _Metric {
  final String label;
  final String value;
  const _Metric(this.label, this.value);
}

class _MetricChip extends StatelessWidget {
  final _Metric metric;
  final ThemeData theme;

  const _MetricChip({required this.metric, required this.theme});

  @override
  Widget build(BuildContext context) {
    final borderColor = theme.colorScheme.onSurface.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.16 : 0.08,
    );
    final secondaryTextColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.72,
    );

    return Container(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Price history table ─────────────────────────────────────────────────

class _PriceHistory extends StatelessWidget {
  final List<PricePoint> points;
  final ThemeData theme;

  const _PriceHistory({required this.points, required this.theme});

  @override
  Widget build(BuildContext context) {
    // Show last 30 days max
    final displayPoints = points.take(30).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Prices',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Simple mini chart: horizontal bar-like representation
        ...displayPoints.map((p) => _PriceRow(point: p, theme: theme)),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final PricePoint point;
  final ThemeData theme;

  const _PriceRow({required this.point, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isUp = point.close >= point.open;
    final palette = PColor();
    final trendColor = isUp ? palette.success : palette.danger;
    final dateStr =
        '${point.date.month.toString().padLeft(2, '0')}/${point.date.day.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(dateStr, style: theme.textTheme.bodySmall),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '\$${point.close.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            isUp ? Icons.arrow_upward : Icons.arrow_downward,
            size: 16,
            color: trendColor,
          ),
          const SizedBox(width: 4),
          Text(
            '${((point.close - point.open) / point.open * 100).toStringAsFixed(2)}%',
            style: TextStyle(fontSize: 12, color: trendColor),
          ),
        ],
      ),
    );
  }
}
