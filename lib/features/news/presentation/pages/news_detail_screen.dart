import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/core/utils/external_link_launcher.dart';
import 'package:mobile/features/news/domain/entities/news.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsEntity article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imageUrl = article.bannerImageUrl;
    final sentimentStyle = _sentimentStyle(theme, article.sentiment);
    final appBarTitle = article.source.trim().isEmpty
        ? 'News Detail'
        : article.source.trim();

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _HeroImage(imageUrl: imageUrl),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.06),
                          Colors.black.withValues(alpha: 0.32),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _SentimentBadge(style: sentimentStyle),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${article.author} - ${article.source} - ${_relativeTime(article.publishedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.summary.isEmpty
                        ? 'Summary not available.'
                        : article.summary,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Market Context',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (article.tickerSentiments.isEmpty)
                    Text(
                      'No ticker sentiment data.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tickerSentiments
                          .map(
                            (ticker) => _TickerChip(
                              ticker: ticker.ticker,
                              label: ticker.label,
                              sentiment: ticker.sentiment,
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isLikelyHttpUrl(article.url)
                          ? () => _openExternalArticle(context)
                          : null,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Read Full Article'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openExternalArticle(BuildContext context) async {
    final didLaunch = await sl<ExternalLinkLauncher>().launch(article.url);
    if (!didLaunch && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Unable to open article link.')),
        );
    }
  }

  bool _isLikelyHttpUrl(String raw) {
    if (raw.trim().isEmpty) return false;
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return false;
    return (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  _SentimentStyle _sentimentStyle(ThemeData theme, NewsSentiment sentiment) {
    final palette = PColor();
    final colorScheme = theme.colorScheme;
    switch (sentiment) {
      case NewsSentiment.bullish:
        return _SentimentStyle(
          label: 'Bullish',
          foreground: palette.success,
          background: palette.success.withValues(alpha: 0.2),
          border: palette.success.withValues(alpha: 0.45),
        );
      case NewsSentiment.bearish:
        return _SentimentStyle(
          label: 'Bearish',
          foreground: colorScheme.error,
          background: colorScheme.error.withValues(alpha: 0.2),
          border: colorScheme.error.withValues(alpha: 0.45),
        );
      case NewsSentiment.neutral:
        return _SentimentStyle(
          label: 'Neutral',
          foreground: colorScheme.onSurfaceVariant,
          background: colorScheme.surfaceContainerHighest,
          border: colorScheme.outlineVariant.withValues(alpha: 0.6),
        );
      case NewsSentiment.unknown:
        return _SentimentStyle(
          label: 'Unknown',
          foreground: colorScheme.onSurfaceVariant,
          background: colorScheme.surfaceContainerHighest,
          border: colorScheme.outlineVariant.withValues(alpha: 0.6),
        );
    }
  }

  String _relativeTime(DateTime publishedAt) {
    final now = DateTime.now();
    final diff = now.difference(publishedAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final weeks = (diff.inDays / 7).floor();
    if (weeks < 5) return '${weeks}w ago';
    final months = (diff.inDays / 30).floor();
    if (months < 12) return '${months}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}

class _HeroImage extends StatelessWidget {
  final String? imageUrl;

  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      color: colorScheme.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: colorScheme.onSurfaceVariant,
      ),
    );

    final url = imageUrl;
    if (url == null || url.isEmpty) return placeholder;

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, imageUrl) =>
          Container(color: colorScheme.surfaceContainerHigh),
      errorWidget: (context, imageUrl, error) => placeholder,
    );
  }
}

class _TickerChip extends StatelessWidget {
  final String ticker;
  final String label;
  final NewsSentiment sentiment;

  const _TickerChip({
    required this.ticker,
    required this.label,
    required this.sentiment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final palette = PColor();

    final Color fg;
    final Color bg;
    switch (sentiment) {
      case NewsSentiment.bullish:
        fg = palette.success;
        bg = palette.success.withValues(alpha: 0.16);
        break;
      case NewsSentiment.bearish:
        fg = colorScheme.error;
        bg = colorScheme.error.withValues(alpha: 0.14);
        break;
      case NewsSentiment.neutral:
      case NewsSentiment.unknown:
        fg = colorScheme.onSurfaceVariant;
        bg = colorScheme.surfaceContainerHighest;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        '$ticker $label',
        style: theme.textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SentimentBadge extends StatelessWidget {
  final _SentimentStyle style;

  const _SentimentBadge({required this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: style.border),
      ),
      child: Text(
        style.label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: style.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SentimentStyle {
  final String label;
  final Color foreground;
  final Color background;
  final Color border;

  const _SentimentStyle({
    required this.label,
    required this.foreground,
    required this.background,
    required this.border,
  });
}
