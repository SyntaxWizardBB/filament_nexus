import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/domain/filament_detail.dart';
import 'package:filament_nexus/features/filaments/domain/filament_rating_kind.dart';
import 'package:filament_nexus/features/filaments/domain/filament_rating_level.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_rating.dart';
import 'package:filament_nexus/shared/widgets/filament_icon.dart';
import 'package:flutter/material.dart';

class FilamentDetailModal extends StatelessWidget {
  const FilamentDetailModal({super.key, required this.filament});

  final Filament filament;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = _buildPropertyTags(filament.details);

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.bg500,
            borderRadius: BorderRadius.all(Radius.circular(AppRadii.card)),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Row(
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
                  ],
                ),
                const _SectionDivider(),
                if (tags.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bg200,
                      borderRadius: BorderRadius.circular(AppRadii.rounded),
                    ),
                    child: Text(
                      'Keine speziellen Eigenschaften',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in tags) _PropertyTag(label: tag),
                    ],
                  ),
                const _SectionDivider(),
                for (final kind in FilamentRatingKind.values)
                  FilamentRating(
                    name: kind.label,
                    rating: kind.read(filament.ratings),
                    lowLabel: kind.lowLabel,
                    highLabel: kind.highLabel,
                  ),
              ],
            ),
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

class _PropertyTag extends StatelessWidget {
  final String label;

  const _PropertyTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bg200,
        borderRadius: BorderRadius.circular(AppRadii.rounded),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textDark),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, thickness: 1, color: AppColors.bg600),
    );
  }
}

List<String> _buildPropertyTags(FilamentDetails details) {
  final tags = <String>[];

  if (details.densityTolerance > 0) {
    tags.add('Dichte: ${_formatNumber(details.densityTolerance)}');
  }
  if (details.meltPointTemp > 0) {
    tags.add('Schmelzpunkt: ${_formatNumber(details.meltPointTemp)}C');
  }
  if (details.glassTransitionTemp > 0) {
    tags.add('Glasübergang: ${_formatNumber(details.glassTransitionTemp)}C');
  }
  if (details.uvResistant) tags.add('UV-resistent');
  if (details.solventResistant) tags.add('Lösungsmittel-resistent');
  if (details.electricallyConductive) tags.add('Elektrisch leitend');
  if (details.magnetic) tags.add('Magnetisch');
  if (details.waterSoluble) tags.add('Wasserlöslich');
  if (details.flexible) tags.add('Flexibel');
  if (details.foodSafe) tags.add('Lebensmittelecht');
  if (details.abrasionResistant) tags.add('Abriebfest');
  if (details.ecoFriendly) tags.add('Umweltfreundlich');
  if (details.fireRetardant) tags.add('Flammhemmend');
  if (details.forLightweightBuild) tags.add('Leichtbau');

  return tags;
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(1);
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
