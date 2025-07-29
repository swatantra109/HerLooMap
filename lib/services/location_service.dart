import 'dart:async';
import '../models/toilet.dart';

class LocationService {
  // Mock user location (London, UK)
  static const double mockLatitude = 51.5074;
  static const double mockLongitude = -0.1278;

  // Get current location (mock implementation)
  Future<Map<String, double>> getCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate location fetch
    
    return {
      'latitude': mockLatitude,
      'longitude': mockLongitude,
    };
  }

  // Get nearby toilets (mock data)
  Future<List<Toilet>> getNearbyToilets(double latitude, double longitude) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    
    return _getMockToilets();
  }

  // Mock toilet data
  List<Toilet> _getMockToilets() {
    return [
      const Toilet(
        id: 'toilet_1',
        name: 'Westfield London - Customer Toilets',
        address: 'Ariel Way, White City, London W12 7GF',
        latitude: 51.5077,
        longitude: -0.2211,
        rating: 4.2,
        reviewCount: 128,
        amenities: ['Free', 'Accessible', 'Baby Changing', 'Hand Dryer'],
        hours: '10:00 AM - 10:00 PM',
        isAccessible: true,
        isFree: true,
        description: 'Clean and well-maintained toilets in Westfield shopping center.',
        images: ['https://via.placeholder.com/300x200'],
        website: 'https://uk.westfield.com',
        phone: '+44 20 8743 8930',
      ),
      const Toilet(
        id: 'toilet_2',
        name: 'Hyde Park Public Facilities',
        address: 'Hyde Park, London W2 2UH',
        latitude: 51.5073,
        longitude: -0.1657,
        rating: 3.8,
        reviewCount: 67,
        amenities: ['Free', 'Accessible', 'Open 24/7'],
        hours: '24/7',
        isAccessible: true,
        isFree: true,
        description: 'Public toilet facilities in Hyde Park.',
        images: ['https://via.placeholder.com/300x200'],
      ),
      const Toilet(
        id: 'toilet_3',
        name: 'Covent Garden Market Toilets',
        address: 'The Market, Covent Garden, London WC2E 8RF',
        latitude: 51.5120,
        longitude: -0.1240,
        rating: 4.0,
        reviewCount: 89,
        amenities: ['Free', 'Baby Changing', 'Hand Sanitizer'],
        hours: '10:00 AM - 8:00 PM',
        isAccessible: false,
        isFree: true,
        description: 'Located in the historic Covent Garden market area.',
        images: ['https://via.placeholder.com/300x200'],
        website: 'https://www.coventgarden.london',
      ),
      const Toilet(
        id: 'toilet_4',
        name: 'King\'s Cross Station Facilities',
        address: 'Euston Rd, London N1 9AL',
        latitude: 51.5308,
        longitude: -0.1238,
        rating: 4.5,
        reviewCount: 203,
        amenities: ['Free', 'Accessible', 'Baby Changing', 'Shower Facilities'],
        hours: '5:00 AM - 1:00 AM',
        isAccessible: true,
        isFree: true,
        description: 'Modern toilet facilities at King\'s Cross St. Pancras station.',
        images: ['https://via.placeholder.com/300x200'],
        phone: '+44 345 711 4141',
      ),
      const Toilet(
        id: 'toilet_5',
        name: 'Tate Modern - Visitor Facilities',
        address: 'Bankside, London SE1 9TG',
        latitude: 51.5076,
        longitude: -0.0994,
        rating: 4.3,
        reviewCount: 156,
        amenities: ['Free', 'Accessible', 'Baby Changing', 'Art Gallery'],
        hours: '10:00 AM - 6:00 PM',
        isAccessible: true,
        isFree: true,
        description: 'Clean facilities within the famous Tate Modern art gallery.',
        images: ['https://via.placeholder.com/300x200'],
        website: 'https://www.tate.org.uk/visit/tate-modern',
        phone: '+44 20 7887 8888',
      ),
    ];
  }
}