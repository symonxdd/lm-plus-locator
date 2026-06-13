/// A single address suggestion returned while the user types, with the
/// coordinates needed to search for nearby offices directly.
class AddressSuggestion {
  const AddressSuggestion({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  final String displayName;
  final double latitude;
  final double longitude;
}
