import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  // Mock OTP verification - accepts any 6-digit code
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    // Demo mode: Accept any 6-digit OTP
    if (otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp)) {
      return true;
    }
    return false;
  }

  // Send OTP to phone number
  Future<bool> sendOTP(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // In demo mode, always return success for valid phone numbers
    if (phoneNumber.length >= 10) {
      return true;
    }
    return false;
  }

  // Create user account after OTP verification
  Future<User?> createUser(String phoneNumber) async {
    try {
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _saveUser(user);
      await _saveToken('demo_token_${user.id}');
      
      return user;
    } catch (e) {
      return null;
    }
  }

  // Google Sign-In (Mock implementation)
  Future<User?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    try {
      final user = User(
        id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
        phoneNumber: '+1234567890', // Mock phone number
        name: 'Demo User',
        email: 'demo@example.com',
        profileImageUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _saveUser(user);
      await _saveToken('google_token_${user.id}');
      
      return user;
    } catch (e) {
      return null;
    }
  }

  // Get current user from storage
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      
      if (userData != null) {
        final userJson = jsonDecode(userData);
        return User.fromJson(userJson);
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userData = prefs.getString(_userKey);
    
    return token != null && userData != null;
  }

  // Sign out user
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  // Private helper methods
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
}