import 'package:flutter_test/flutter_test.dart';
import 'package:her_loo_map/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('should verify valid OTP', () async {
      // Act
      final result = await authService.verifyOTP('+1234567890', '123456');

      // Assert
      expect(result, true);
    });

    test('should reject invalid OTP', () async {
      // Act
      final result = await authService.verifyOTP('+1234567890', '12345');

      // Assert
      expect(result, false);
    });

    test('should reject non-numeric OTP', () async {
      // Act
      final result = await authService.verifyOTP('+1234567890', 'abcdef');

      // Assert
      expect(result, false);
    });

    test('should send OTP for valid phone number', () async {
      // Act
      final result = await authService.sendOTP('+1234567890');

      // Assert
      expect(result, true);
    });

    test('should reject OTP for invalid phone number', () async {
      // Act
      final result = await authService.sendOTP('123');

      // Assert
      expect(result, false);
    });

    test('should create user after verification', () async {
      // Act
      final user = await authService.createUser('+1234567890');

      // Assert
      expect(user, isNotNull);
      expect(user!.phoneNumber, '+1234567890');
      expect(user.id, isNotEmpty);
    });

    test('should sign in with Google', () async {
      // Act
      final user = await authService.signInWithGoogle();

      // Assert
      expect(user, isNotNull);
      expect(user!.name, 'Demo User');
      expect(user.email, 'demo@example.com');
    });
  });
}