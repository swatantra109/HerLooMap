import 'package:flutter_test/flutter_test.dart';
import 'package:her_loo_map/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('should create user from JSON', () {
      // Arrange
      final json = {
        'id': 'user123',
        'phoneNumber': '+1234567890',
        'name': 'Test User',
        'email': 'test@example.com',
        'profileImageUrl': 'https://example.com/avatar.jpg',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'lastLoginAt': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, 'user123');
      expect(user.phoneNumber, '+1234567890');
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.profileImageUrl, 'https://example.com/avatar.jpg');
    });

    test('should convert user to JSON', () {
      // Arrange
      final user = User(
        id: 'user123',
        phoneNumber: '+1234567890',
        name: 'Test User',
        email: 'test@example.com',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        lastLoginAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], 'user123');
      expect(json['phoneNumber'], '+1234567890');
      expect(json['name'], 'Test User');
      expect(json['email'], 'test@example.com');
    });

    test('should copy user with new values', () {
      // Arrange
      final user = User(
        id: 'user123',
        phoneNumber: '+1234567890',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Act
      final updatedUser = user.copyWith(name: 'Updated Name', email: 'new@example.com');

      // Assert
      expect(updatedUser.id, user.id);
      expect(updatedUser.phoneNumber, user.phoneNumber);
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.email, 'new@example.com');
    });
  });
}