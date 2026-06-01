import 'package:filament_nexus/features/filaments/domain/filament_rating_kind.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/filament_form_controller.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/pill_row.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/rating_bar.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/text_pill.dart';
import 'package:flutter/material.dart';

/// Tab "Bewertung": five 0-10 ratings plus a free-text remark.
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
          RatingBar(
            value: form.ratings[rating] ?? 0,
            onChanged: (v) => onRatingChanged(rating, v),
          ),
          const SizedBox(height: 16),
        ],
        const FieldLabel('Bemerkung'),
        const SizedBox(height: 6),
        TextPill(controller: form.remark, minLines: 4, maxLines: 6),
      ],
    );
  }
}
