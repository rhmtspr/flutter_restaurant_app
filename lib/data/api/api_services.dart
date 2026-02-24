import 'dart:convert';

// ignore: unused_import
import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_list_response.dart';
// ignore: unused_import
import 'package:flutter_restaurant_app/data/model/tourism_detail_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      // print(RestaurantListResponse.fromJson(jsonDecode(response.body)));
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  // Future<TourismDetailResponse> getTourismDetail(int id) async {
  //   final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

  //   if (response.statusCode == 200) {
  //     return TourismDetailResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load tourism detail');
  //   }
  // }
}
