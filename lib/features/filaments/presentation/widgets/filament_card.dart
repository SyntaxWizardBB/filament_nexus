import 'package:flutter/material.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';

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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _FilamentIcon(color: Colors.green.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${filament.type.name.toUpperCase()}  ${filament.vendor.name}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey.shade700,
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
              Icon(Icons.chevron_right, color: Colors.grey.shade700),
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
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(child: Icon(Icons.album, color: color, size: 24)),
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
        Icon(icon, size: 14, color: Colors.grey.shade800),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade900,
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
