import 'dart:convert';

// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/add_review_response.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_model.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_list_response.dart';
// ignore: unused_import
import 'package:flutter_restaurant_app/data/model/restaurant_detail_response.dart';
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

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tourism detail');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

    final decoded = jsonDecode(response.body);
    print("decoded: $decoded");

    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to search restaurant");
    }
  }

  Future<AddReviewResponse> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "name": name, "review": review}),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AddReviewResponse.fromJson(decoded);
    } else {
      throw Exception("Failed to add review");
    }
  }
}
