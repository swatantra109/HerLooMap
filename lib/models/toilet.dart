class Toilet {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final String hours;
  final bool isAccessible;
  final bool isFree;
  final String? description;
  final List<String> images;
  final String? website;
  final String? phone;

  const Toilet({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.hours,
    required this.isAccessible,
    required this.isFree,
    this.description,
    required this.images,
    this.website,
    this.phone,
  });

  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      amenities: List<String>.from(json['amenities'] as List),
      hours: json['hours'] as String,
      isAccessible: json['isAccessible'] as bool,
      isFree: json['isFree'] as bool,
      description: json['description'] as String?,
      images: List<String>.from(json['images'] as List),
      website: json['website'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviewCount': reviewCount,
      'amenities': amenities,
      'hours': hours,
      'isAccessible': isAccessible,
      'isFree': isFree,
      'description': description,
      'images': images,
      'website': website,
      'phone': phone,
    };
  }
}