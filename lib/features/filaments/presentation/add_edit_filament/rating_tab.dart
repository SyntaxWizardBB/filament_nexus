import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/features/filaments/domain/filament_rating_kind.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/filament_form_controller.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/pill_row.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/rating_bar.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/text_pill.dart';
import 'package:flutter/material.dart';

/// Tab "Bewertung": five 0-10 ratings plus a free-text description.
class RatingTab extends StatelessWidget {
  final FilamentFormController form;
  final void Function(FilamentRatingKind, int) onRatingChanged;

  const RatingTab({
    super.key,
    required this.form,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        for (final rating in FilamentRatingKind.values) ...[
          FieldLabel(rating.label),
          const SizedBox(height: 6),
          _ScaleEnds(low: rating.lowLabel, high: rating.highLabel),
          const SizedBox(height: 4),
          RatingBar(
            value: form.ratings[rating] ?? 0,
            onChanged: (v) => onRatingChanged(rating, v),
          ),
          const SizedBox(height: 16),
        ],
        const FieldLabel('Bemerkung'),
        const SizedBox(height: 6),
        TextPill(controller: form.description, minLines: 4, maxLines: 6),
      ],
    );
  }
}

/// Shows what the low (0) and high (10) ends of a rating bar mean,
/// aligned left (bad) and right (good) above the bar.
class _ScaleEnds extends StatelessWidget {
  final String low;
  final String high;

  const _ScaleEnds({required this.low, required this.high});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: AppColors.textLight);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(low, style: style),
        Text(high, style: style),
      ],
    );
  }
}
