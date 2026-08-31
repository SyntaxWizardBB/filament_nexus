import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/domain/filament_rating_level.dart';
import 'package:filament_nexus/shared/widgets/filament_icon.dart';
import 'package:flutter/material.dart';

class FilamentCard extends StatelessWidget {
  final Filament filament;
  final VoidCallback? onTap;

  const FilamentCard({super.key, required this.filament, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.bg300,
            borderRadius: BorderRadius.circular(AppRadii.card),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _FilamentIcon(color: filament.ratings.level.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${filament.type.name.toUpperCase()}  ${filament.vendor.name}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textLight,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      filament.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _SpecRow(
                          icon: Icons.local_fire_department,
                          text: _rangeText(
                            filament.printTempMin,
                            filament.printTempMax,
                            unit: 'C',
                          ),
                        ),
                        _SpecRow(
                          icon: Icons.grid_on,
                          text: _rangeText(
                            filament.bedTempMin,
                            filament.bedTempMax,
                            unit: 'C',
                          ),
                        ),
                        _SpecRow(
                          icon: Icons.speed,
                          text: _rangeText(
                            filament.printSpeedMin,
                            filament.printSpeedMax,
                            unit: 'mm/s',
                          ),
                        ),
                        _SpecRow(
                          icon: Icons.air,
                          text: _fanText(
                            filament.fanSpeedFirstLayer,
                            filament.fanSpeed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.textLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilamentIcon extends StatelessWidget {
  final Color color;

  const _FilamentIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(child: filamentIcon(color: color)),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SpecRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}

String _rangeText(int min, int max, {required String unit}) {
  if (min == 0 && max == 0) {
    return '--';
  }

  if (min == max) {
    return '$min$unit';
  }

  return '$min-$max$unit';
}

String _fanText(int firstLayer, int regular) {
  if (firstLayer == 0 && regular == 0) {
    return '--';
  }

  if (firstLayer == 0 || firstLayer == regular) {
    return '$regular%';
  }

  return '$firstLayer% / $regular%';
}
