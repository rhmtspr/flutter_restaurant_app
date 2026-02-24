import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/api/api_services.dart';
import 'package:flutter_restaurant_app/static/restaurant_search_result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiServices apiServices;

  RestaurantSearchProvider(this.apiServices);

  RestaurantSearchResultState _state = RestaurantSearchNoneState();
  RestaurantSearchResultState get state => _state;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _state = RestaurantSearchNoneState();
      notifyListeners();
      return;
    }

    try {
      _state = RestaurantSearchLoadingState();
      notifyListeners();

      final result = await apiServices.searchRestaurant(query);

      print("result: ${result.restaurants}");

      if (result.restaurants.isEmpty) {
        _state = RestaurantSearchNoneState();
      } else {
        _state = RestaurantSearchLoadedState(result.restaurants);
      }
    } catch (e) {
      _state = RestaurantSearchErrorState(e.toString());
    }

    notifyListeners();
  }
}
