import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize auth state
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUser();
      _clearError();
    } catch (e) {
      _setError('Failed to initialize authentication');
    }
    _setLoading(false);
  }

  // Send OTP to phone number
  Future<bool> sendOTP(String phoneNumber) async {
    _setLoading(true);
    try {
      final success = await _authService.sendOTP(phoneNumber);
      if (success) {
        _clearError();
        return true;
      } else {
        _setError('Failed to send OTP. Please check your phone number.');
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP and sign in
  Future<bool> verifyOTPAndSignIn(String phoneNumber, String otp) async {
    _setLoading(true);
    try {
      final isValid = await _authService.verifyOTP(phoneNumber, otp);
      if (isValid) {
        _user = await _authService.createUser(phoneNumber);
        if (_user != null) {
          _clearError();
          notifyListeners();
          return true;
        } else {
          _setError('Failed to create user account');
          return false;
        }
      } else {
        _setError('Invalid OTP. Please try again.');
        return false;
      }
    } catch (e) {
      _setError('Verification failed. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      _user = await _authService.signInWithGoogle();
      if (_user != null) {
        _clearError();
        notifyListeners();
        return true;
      } else {
        _setError('Google sign-in failed');
        return false;
      }
    } catch (e) {
      _setError('Google sign-in error. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to sign out');
    }
    _setLoading(false);
  }

  // Clear any existing errors
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}