/// A single LM+ office location, as scraped into assets/lm_offices.json.
class Office {
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String phone;
  final double lat;
  final double lng;

  const Office({
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postal_code'] as String,
      phone: json['phone'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  /// The full postal address, e.g. "Bellemstraat 24, 9880 Aalter".
  String get fullAddress => '$address, $postalCode $city';
}

/// An [Office] paired with its distance from the user, in kilometers.
class OfficeWithDistance {
  final Office office;
  final double distanceKm;

  const OfficeWithDistance({required this.office, required this.distanceKm});
}
