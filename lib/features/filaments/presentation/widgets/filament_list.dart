import 'package:flutter/material.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_card.dart';

class FilamentList extends StatelessWidget {
  final List<Filament> filaments;
  final ValueChanged<Filament>? onTap;

  FilamentList({super.key, List<Filament>? filaments, this.onTap})
    : filaments = filaments ?? [];

  @override
  Widget build(BuildContext context) {
    if (filaments.isEmpty) {
      return const SizedBox.shrink();
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
