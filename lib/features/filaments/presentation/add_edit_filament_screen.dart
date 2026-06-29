import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/features/filaments/data/filament_repository.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/details_tab.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/filament_form_controller.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/general_tab.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/rating_tab.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/segmented_tab_selector.dart';
import 'package:flutter/material.dart';

/// Create / edit screen for a single filament.
///
/// Same screen serves both flows:
/// - [filament] == null  -> "Neues Filament" (empty)
/// - [filament] != null  -> "Filament bearbeiten" (prefilled via the form
///   controller)
///
/// The three tabs share one [FilamentFormController], so switching tabs never
/// loses input (kept alive via [IndexedStack]).
class AddEditFilamentScreen extends StatefulWidget {
  final Filament? filament;

  const AddEditFilamentScreen({super.key, this.filament});

  bool get isEditing => filament != null;

  @override
  State<AddEditFilamentScreen> createState() => _AddEditFilamentScreenState();
}

class _AddEditFilamentScreenState extends State<AddEditFilamentScreen> {
  static const _tabLabels = ['Allgemein', 'Details', 'Bewertung'];

  late final FilamentFormController _form;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _form = FilamentFormController.fromFilament(widget.filament);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _goToTab(int index) {
    if (index < 0 || index >= _tabLabels.length) return;
    setState(() => _tabIndex = index);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filament löschen'),
        content: const Text(
          'Dieses Filament wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      FilamentRepository.instance.delete(widget.filament!.id);
      Navigator.of(context).pop();
    }
  }

  void _save() {
    // All validated fields live on the "Allgemein" tab — jump there on error.
    final error = _form.validationError();
    if (error != null) {
      setState(() => _tabIndex = 0);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final id =
        widget.filament?.id ?? 'f-${DateTime.now().millisecondsSinceEpoch}';
    FilamentRepository.instance.save(_form.toFilament(id: id));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isEditing ? 'Filament bearbeiten' : 'Neues Filament'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: 'Löschen',
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Column(
        children: [
          SegmentedTabSelector(
            labels: _tabLabels,
            selectedIndex: _tabIndex,
            onChanged: _goToTab,
          ),
          const Divider(height: 1),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                GeneralTab(
                  form: _form,
                  onTypeChanged: (v) => setState(() => _form.type = v),
                  onVendorChanged: (v) => setState(() => _form.vendor = v),
                ),
                DetailsTab(
                  form: _form,
                  onPropertyChanged: (p, v) =>
                      setState(() => _form.properties[p] = v),
                ),
                RatingTab(
                  form: _form,
                  onRatingChanged: (r, v) =>
                      setState(() => _form.ratings[r] = v),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// When creating, tabs 1+2 show "Weiter" (advance) and only the last tab
  /// shows "Speichern". When editing, every tab shows "Speichern".
  Widget _buildBottomBar() {
    final isLastTab = _tabIndex == _tabLabels.length - 1;
    final saveMode = widget.isEditing || isLastTab;

    return _BottomBar(
      label: saveMode ? 'Speichern' : 'Weiter',
      onPressed: saveMode ? _save : () => _goToTab(_tabIndex + 1),
    );
  }
}

/// Bottom action bar with a single full-width button. The label/action is
/// decided by the screen ("Weiter" to advance vs. "Speichern" to persist).
class _BottomBar extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _BottomBar({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.rounded),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
