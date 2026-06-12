import 'package:flutter_test/flutter_test.dart';
import 'package:lm_plus_locator/models/office.dart';
import 'package:lm_plus_locator/services/office_service.dart';

void main() {
  final officeService = OfficeService();

  // Brussels and Antwerp, roughly 44 km apart as the crow flies.
  final brussels = Office(
    name: 'LM Plus Brussel',
    address: 'Teststraat 1',
    city: 'Brussel',
    postalCode: '1000',
    phone: '02 000 00 00',
    lat: 50.8503,
    lng: 4.3517,
  );
  final antwerp = Office(
    name: 'LM Plus Antwerpen',
    address: 'Teststraat 2',
    city: 'Antwerpen',
    postalCode: '2000',
    phone: '03 000 00 00',
    lat: 51.2194,
    lng: 4.4025,
  );
  final ghent = Office(
    name: 'LM Plus Gent',
    address: 'Teststraat 3',
    city: 'Gent',
    postalCode: '9000',
    phone: '09 000 00 00',
    lat: 51.0543,
    lng: 3.7174,
  );

  test('nearestOffices sorts offices by ascending distance', () {
    final result = officeService.nearestOffices(
      offices: [antwerp, ghent, brussels],
      userLat: brussels.lat,
      userLng: brussels.lng,
    );

    expect(result.first.office.name, brussels.name);
    expect(result.first.distanceKm, closeTo(0, 0.01));
    expect(result.map((o) => o.office.name), [
      brussels.name,
      antwerp.name,
      ghent.name,
    ]);
  });

  test('nearestOffices returns all offices', () {
    final result = officeService.nearestOffices(
      offices: [antwerp, ghent, brussels],
      userLat: brussels.lat,
      userLng: brussels.lng,
    );

    expect(result.length, 3);
  });

  test('haversine distance between Brussels and Antwerp is ~41km', () {
    final result = officeService.nearestOffices(
      offices: [antwerp],
      userLat: brussels.lat,
      userLng: brussels.lng,
    );

    expect(result.single.distanceKm, closeTo(41, 2));
  });
}
