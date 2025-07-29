import 'package:flutter_test/flutter_test.dart';
import 'package:her_loo_map/models/toilet.dart';

void main() {
  group('Toilet Model Tests', () {
    test('should create toilet from JSON', () {
      // Arrange
      final json = {
        'id': 'toilet123',
        'name': 'Test Toilet',
        'address': '123 Test Street',
        'latitude': 51.5074,
        'longitude': -0.1278,
        'rating': 4.5,
        'reviewCount': 100,
        'amenities': ['Free', 'Accessible'],
        'hours': '9:00 AM - 6:00 PM',
        'isAccessible': true,
        'isFree': true,
        'description': 'A nice clean toilet',
        'images': ['https://example.com/image.jpg'],
        'website': 'https://example.com',
        'phone': '+1234567890',
      };

      // Act
      final toilet = Toilet.fromJson(json);

      // Assert
      expect(toilet.id, 'toilet123');
      expect(toilet.name, 'Test Toilet');
      expect(toilet.address, '123 Test Street');
      expect(toilet.latitude, 51.5074);
      expect(toilet.longitude, -0.1278);
      expect(toilet.rating, 4.5);
      expect(toilet.reviewCount, 100);
      expect(toilet.amenities, ['Free', 'Accessible']);
      expect(toilet.hours, '9:00 AM - 6:00 PM');
      expect(toilet.isAccessible, true);
      expect(toilet.isFree, true);
      expect(toilet.description, 'A nice clean toilet');
      expect(toilet.images, ['https://example.com/image.jpg']);
      expect(toilet.website, 'https://example.com');
      expect(toilet.phone, '+1234567890');
    });

    test('should convert toilet to JSON', () {
      // Arrange
      const toilet = Toilet(
        id: 'toilet123',
        name: 'Test Toilet',
        address: '123 Test Street',
        latitude: 51.5074,
        longitude: -0.1278,
        rating: 4.5,
        reviewCount: 100,
        amenities: ['Free', 'Accessible'],
        hours: '9:00 AM - 6:00 PM',
        isAccessible: true,
        isFree: true,
        description: 'A nice clean toilet',
        images: ['https://example.com/image.jpg'],
        website: 'https://example.com',
        phone: '+1234567890',
      );

      // Act
      final json = toilet.toJson();

      // Assert
      expect(json['id'], 'toilet123');
      expect(json['name'], 'Test Toilet');
      expect(json['address'], '123 Test Street');
      expect(json['latitude'], 51.5074);
      expect(json['longitude'], -0.1278);
      expect(json['rating'], 4.5);
      expect(json['reviewCount'], 100);
      expect(json['amenities'], ['Free', 'Accessible']);
      expect(json['isAccessible'], true);
      expect(json['isFree'], true);
    });
  });
}