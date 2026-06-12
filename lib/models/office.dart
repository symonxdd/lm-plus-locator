/// Whether a location is a full office (with opening hours and a live
/// "open now" status on the LM+ site) or a mailbox-only drop-off point.
enum OfficeType { office, mailbox }

/// A location's weekly opening hours, as scraped from the LM+ site.
///
/// [slotsByWeekday] maps weekday numbers (0 = Sunday .. 6 = Saturday,
/// matching the source site's convention) to a list of `[start, end]` time
/// slots, each expressed as an HHMM integer (e.g. `900` for 9:00, `1630`
/// for 16:30). An empty list means closed all day.
class OpeningHours {
  final Map<int, List<List<int>>> slotsByWeekday;

  const OpeningHours(this.slotsByWeekday);

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours({
      for (final entry in json.entries)
        int.parse(entry.key): (entry.value as List<dynamic>)
            .map(
              (slot) => (slot as List<dynamic>).map((v) => v as int).toList(),
            )
            .toList(),
    });
  }

  /// Whether the location is open at [time].
  bool isOpenAt(DateTime time) {
    final weekday = time.weekday % 7; // DateTime: 1=Mon..7=Sun -> 0=Sun..6=Sat
    final minutesNow = time.hour * 60 + time.minute;

    for (final slot in slotsByWeekday[weekday] ?? const []) {
      if (minutesNow >= _hhmmToMinutes(slot[0]) &&
          minutesNow < _hhmmToMinutes(slot[1])) {
        return true;
      }
    }
    return false;
  }

  static int _hhmmToMinutes(int hhmm) => (hhmm ~/ 100) * 60 + (hhmm % 100);
}

/// A single LM+ office location, as scraped into assets/lm_offices.json.
class Office {
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String phone;
  final double lat;
  final double lng;
  final OfficeType type;
  final OpeningHours? openingHours;

  const Office({
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.lat,
    required this.lng,
    this.type = OfficeType.office,
    this.openingHours,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    final openingHoursJson = json['opening_hours'] as Map<String, dynamic>?;
    return Office(
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postal_code'] as String,
      phone: json['phone'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      type: json['type'] == 'mailbox' ? OfficeType.mailbox : OfficeType.office,
      openingHours: openingHoursJson != null
          ? OpeningHours.fromJson(openingHoursJson)
          : null,
    );
  }

  /// The full postal address, e.g. "Bellemstraat 24, 9880 Aalter".
  String get fullAddress => '$address, $postalCode $city';

  /// Whether the office is currently open, or `null` if its opening hours
  /// aren't known (e.g. mailbox entries, or "by appointment" offices).
  bool? get isOpenNow => openingHours?.isOpenAt(DateTime.now());
}

/// An [Office] paired with its distance from the user, in kilometers.
class OfficeWithDistance {
  final Office office;
  final double distanceKm;

  const OfficeWithDistance({required this.office, required this.distanceKm});
}
