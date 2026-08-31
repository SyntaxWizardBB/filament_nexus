import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_card.dart';
import 'package:flutter/material.dart';

/// Renders the filament list and the states around it:
/// loading (spinner while fetching the first page), error, empty, plus an
/// infinite-scroll footer that pulls the next page.
class FilamentList extends StatelessWidget {
  final List<Filament> filaments;
  final ValueChanged<Filament>? onTap;
  final bool isLoading;
  final String? error;
  final String emptyMessage;

  /// Called when the list is scrolled near its end and more pages exist.
  final VoidCallback? onEndReached;

  /// Whether a follow-up page is currently being fetched.
  final bool isLoadingMore;

  /// Whether at least one more page can be loaded.
  final bool hasMore;

  /// Set when the last [onEndReached] attempt failed — the footer offers a retry.
  final String? loadMoreError;

  /// How many pixels before the bottom edge [onEndReached] should fire.
  static const _endReachedThreshold = 300.0;

  FilamentList({
    super.key,
    required List<Filament>? filaments,
    this.onTap,
    this.isLoading = false,
    this.error,
    this.emptyMessage = 'Keine Filamente vorhanden.',
    this.onEndReached,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.loadMoreError,
  }) : filaments = filaments ?? [];

  bool get _hasFooter =>
      hasMore || isLoadingMore || loadMoreError != null;

  @override
  Widget build(BuildContext context) {
    // First page is still being fetched from the data source.
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _Message(icon: Icons.cloud_off, text: error!);
    }

    if (filaments.isEmpty) {
      // Nothing loaded matches — but more pages may still hold a match, so
      // keep the footer reachable (client-side search only sees loaded pages).
      if (_hasFooter) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _Message(icon: Icons.inbox_outlined, text: emptyMessage),
            ),
            _Footer(
              isLoadingMore: isLoadingMore,
              error: loadMoreError,
              onLoadMore: _maybeLoadMore,
            ),
            const SizedBox(height: 24),
          ],
        );
      }
      return _Message(icon: Icons.inbox_outlined, text: emptyMessage);
    }

    final itemCount = filaments.length + (_hasFooter ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics.axis == Axis.vertical &&
            metrics.pixels >= metrics.maxScrollExtent - _endReachedThreshold) {
          _maybeLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= filaments.length) {
            return _Footer(
              isLoadingMore: isLoadingMore,
              error: loadMoreError,
              onLoadMore: _maybeLoadMore,
            );
          }

          final filament = filaments[index];
          return FilamentCard(
            filament: filament,
            onTap: onTap == null ? null : () => onTap!(filament),
          );
        },
      ),
    );
  }

  void _maybeLoadMore() {
    if (hasMore && !isLoadingMore && onEndReached != null) {
      onEndReached!();
    }
  }
}

/// Footer row below the list: a spinner while a page loads, a retry on error,
/// or a "load more" button (also triggered automatically by scrolling).
class _Footer extends StatelessWidget {
  final bool isLoadingMore;
  final String? error;
  final VoidCallback onLoadMore;

  const _Footer({
    required this.isLoadingMore,
    required this.error,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              error!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textLight,
              ),
            ),
            TextButton(
              onPressed: onLoadMore,
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: TextButton(
          onPressed: onLoadMore,
          child: const Text('Mehr laden'),
        ),
      ),
    );
  }
}

/// Centered icon + text used for the empty and error states.
class _Message extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Message({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textLight),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
