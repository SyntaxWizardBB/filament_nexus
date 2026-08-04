import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_card.dart';
import 'package:flutter/material.dart';

/// Renders the filament list and the three states around it:
/// loading (spinner while fetching), error, and empty.
class FilamentList extends StatelessWidget {
  final List<Filament> filaments;
  final ValueChanged<Filament>? onTap;
  final bool isLoading;
  final String? error;
  final String emptyMessage;

  FilamentList({
    super.key,
    required List<Filament>? filaments,
    this.onTap,
    this.isLoading = false,
    this.error,
    this.emptyMessage = 'Keine Filamente vorhanden.',
  }) : filaments = filaments ?? [];

  @override
  Widget build(BuildContext context) {
    // Data is still being fetched from the data source.
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _Message(icon: Icons.cloud_off, text: error!);
    }

    if (filaments.isEmpty) {
      return _Message(icon: Icons.inbox_outlined, text: emptyMessage);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: filaments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final filament = filaments[index];

        return FilamentCard(
          filament: filament,
          onTap: onTap == null ? null : () => onTap!(filament),
        );
      },
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
