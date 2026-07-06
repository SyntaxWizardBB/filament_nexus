class FilamentVendor {
  final String name;

  const FilamentVendor({required this.name});

  // Value equality so the same vendor matches across drodown options and data.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is FilamentVendor && other.name == name);

  @override
  int get hashCode => name.hashCode;

  Map<String, dynamic> toJson() => {'name': name};

  factory FilamentVendor.fromJson(Map<String, dynamic> json) =>
      FilamentVendor(name: json['name'] as String? ?? '');
}

// Predefined, selectable vendors for the dropdown
const List<FilamentVendor> kFilamentVendors = [
  FilamentVendor(name: 'Bambulab'),
  FilamentVendor(name: 'Prusa'),
  FilamentVendor(name: 'eSUN'),
  FilamentVendor(name: 'Overture'),
  FilamentVendor(name: 'Polymaker'),
];
