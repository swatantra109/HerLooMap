import 'package:flutter_test/flutter_test.dart';
import 'package:her_loo_map/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    test('should return mock location', () async {
      // Act
      final location = await locationService.getCurrentLocation();

      // Assert
      expect(location['latitude'], 51.5074);
      expect(location['longitude'], -0.1278);
    });

    test('should return nearby toilets', () async {
      // Act
      final toilets = await locationService.getNearbyToilets(51.5074, -0.1278);

      // Assert
      expect(toilets, isNotEmpty);
      expect(toilets.length, 5);
      expect(toilets.first.name, 'Westfield London - Customer Toilets');
    });

    test('should return toilets with required properties', () async {
      // Act
      final toilets = await locationService.getNearbyToilets(51.5074, -0.1278);

      // Assert
      for (final toilet in toilets) {
        expect(toilet.id, isNotEmpty);
        expect(toilet.name, isNotEmpty);
        expect(toilet.address, isNotEmpty);
        expect(toilet.latitude, isA<double>());
        expect(toilet.longitude, isA<double>());
        expect(toilet.rating, greaterThan(0));
        expect(toilet.reviewCount, greaterThan(0));
        expect(toilet.amenities, isNotEmpty);
        expect(toilet.hours, isNotEmpty);
      }
    });

    test('should return toilets with different accessibility levels', () async {
      // Act
      final toilets = await locationService.getNearbyToilets(51.5074, -0.1278);

      // Assert
      final accessibleToilets = toilets.where((t) => t.isAccessible).toList();
      final nonAccessibleToilets = toilets.where((t) => !t.isAccessible).toList();
      
      expect(accessibleToilets, isNotEmpty);
      expect(nonAccessibleToilets, isNotEmpty);
    });
  });
}