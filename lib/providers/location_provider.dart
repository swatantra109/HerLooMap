import 'package:flutter/foundation.dart';
import '../models/toilet.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  
  double? _latitude;
  double? _longitude;
  List<Toilet> _toilets = [];
  bool _isLoading = false;
  String? _error;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  List<Toilet> get toilets => _toilets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _latitude != null && _longitude != null;

  // Initialize location and load toilets
  Future<void> initialize() async {
    await getCurrentLocation();
    if (hasLocation) {
      await loadNearbyToilets();
    }
  }

  // Get current user location
  Future<void> getCurrentLocation() async {
    _setLoading(true);
    try {
      final location = await _locationService.getCurrentLocation();
      _latitude = location['latitude'];
      _longitude = location['longitude'];
      _clearError();
    } catch (e) {
      _setError('Failed to get current location');
    }
    _setLoading(false);
  }

  // Load nearby toilets
  Future<void> loadNearbyToilets() async {
    if (!hasLocation) {
      _setError('Location not available');
      return;
    }

    _setLoading(true);
    try {
      _toilets = await _locationService.getNearbyToilets(_latitude!, _longitude!);
      _clearError();
    } catch (e) {
      _setError('Failed to load nearby toilets');
    }
    _setLoading(false);
  }

  // Refresh data
  Future<void> refresh() async {
    await getCurrentLocation();
    if (hasLocation) {
      await loadNearbyToilets();
    }
  }

  // Get toilet by ID
  Toilet? getToiletById(String id) {
    try {
      return _toilets.firstWhere((toilet) => toilet.id == id);
    } catch (e) {
      return null;
    }
  }

  // Calculate distance between two points (simplified)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Helper methods for math functions
  double sin(double x) => x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  double cos(double x) => 1 - (x * x) / 2 + (x * x * x * x) / 24;
  double sqrt(double x) => x * 0.5; // Simplified
  double atan2(double y, double x) => y / x; // Simplified
  static const double pi = 3.14159265359;

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