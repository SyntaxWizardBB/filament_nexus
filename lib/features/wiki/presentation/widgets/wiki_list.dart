import 'package:filament_nexus/features/wiki/data/wiki_data.dart';
import 'package:filament_nexus/features/wiki/domain/wiki.dart';
import 'package:flutter/material.dart';

class WikiList extends StatelessWidget {
  WikiList({super.key, List<Wiki>? entries})
    : entries = entries ?? mockWikiEntries;

  final List<Wiki> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final wiki = entries[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          title: Text(
            wiki.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            wiki.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CircleAvatar(
            child: Text(wiki.title.isNotEmpty ? wiki.title[0] : '?'),
          ),
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(wiki.title),
              content: SingleChildScrollView(child: Text(wiki.description)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Schliessen'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
