import 'package:filament_nexus/features/wiki/data/wiki_data.dart';
import 'package:filament_nexus/features/wiki/domain/wiki.dart';
import 'package:flutter/material.dart';

class WikiList extends StatelessWidget {
  WikiList({super.key, List<Wiki>? entries})
    : entries = entries ?? mockWikiEntries;

  final List<Wiki> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: entries.length,
      itemBuilder: (context, index) => _WikiCard(wiki: entries[index]),
    );
  }
}

class _WikiCard extends StatelessWidget {
  const _WikiCard({required this.wiki});

  final Wiki wiki;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wiki.imagePath != null)
              _WikiImage(path: wiki.imagePath!, height: 160),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wiki.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    wiki.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(wiki.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (wiki.imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _WikiImage(path: wiki.imagePath!, height: 180),
                ),
                const SizedBox(height: 12),
              ],
              Text(wiki.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schliessen'),
          ),
        ],
      ),
    );
  }
}

class _WikiImage extends StatelessWidget {
  const _WikiImage({required this.path, required this.height});

  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, _, _) => Container(
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
