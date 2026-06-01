class FilamentType {
  final String name;

  const FilamentType({required this.name});

  // Value equality so the same type matches across dropdown options and data.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is FilamentType && other.name == name);

  @override
  int get hashCode => name.hashCode;
}

// Predefined, selectable filament types for the dropdown.
const List<FilamentType> kFilamentTypes = [
  FilamentType(name: 'PLA'),
  FilamentType(name: 'PETG'),
  FilamentType(name: 'ABS'),
  FilamentType(name: 'TPU'),
  FilamentType(name: 'ASA'),
  FilamentType(name: 'PC'),
  FilamentType(name: 'PA-CF'),
];
