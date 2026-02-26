import 'package:flutter_restaurant_app/data/model/restaurant_detail_model.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }

  Restaurant toRestaurant(RestaurantDetail detail) {
    return Restaurant(
      id: detail.id,
      name: detail.name,
      description: detail.description,
      city: detail.city,
      pictureId: detail.pictureId,
      rating: detail.rating,
    );
  }
}

class RestaurantSearchResponse {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  RestaurantSearchResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearchResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantSearchResponse(
      error: json['error'] ?? false,
      founded: json['founded'] ?? 0,
      restaurants:
          (json['restaurants'] as List?)
              ?.map((e) => Restaurant.fromJson(e))
              .toList() ??
          [],
    );
  }
}
