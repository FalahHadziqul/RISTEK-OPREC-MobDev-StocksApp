import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/features/news/domain/entities/news.dart';

class NewsCard extends StatelessWidget {
  final NewsEntity article;
  final VoidCallback? onTap;

  const NewsCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sentimentStyle = _sentimentStyle(theme, article.sentiment);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NewsImage(imageUrl: article.bannerImageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SentimentBadge(style: sentimentStyle),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Author: ${article.author}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${article.source} • ${_relativeTime(article.publishedAt)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _SentimentStyle _sentimentStyle(ThemeData theme, NewsSentiment sentiment) {
    final palette = PColor();
    final colorScheme = theme.colorScheme;

    switch (sentiment) {
      case NewsSentiment.bullish:
        return _SentimentStyle(
          label: 'Bullish',
          foreground: palette.success,
          background: palette.success.withValues(alpha: 0.14),
          border: palette.success.withValues(alpha: 0.45),
        );
      case NewsSentiment.bearish:
        return _SentimentStyle(
          label: 'Bearish',
          foreground: colorScheme.error,
          background: colorScheme.error.withValues(alpha: 0.12),
          border: colorScheme.error.withValues(alpha: 0.4),
        );
      case NewsSentiment.neutral:
        return _SentimentStyle(
          label: 'Neutral',
          foreground: colorScheme.onSurfaceVariant,
          background: colorScheme.surfaceContainerHighest,
          border: colorScheme.outlineVariant.withValues(alpha: 0.5),
        );
      case NewsSentiment.unknown:
        return _SentimentStyle(
          label: 'Unknown',
          foreground: colorScheme.onSurfaceVariant,
          background: colorScheme.surfaceContainerHighest,
          border: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
    final years = (diff.inDays / 365).floor();
    return '${years}y ago';
  }
}

class _NewsImage extends StatelessWidget {
  final String? imageUrl;

  const _NewsImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colorScheme.onSurfaceVariant,
      ),
    );

    final url = imageUrl;
    if (url == null || url.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        placeholder: (context, imageUrl) => Container(
          width: 88,
          height: 88,
          color: colorScheme.surfaceContainerHigh,
        ),
        errorWidget: (context, imageUrl, error) => placeholder,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: style.border),
      ),
      child: Text(
        style.label,
        style: theme.textTheme.labelSmall?.copyWith(
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
