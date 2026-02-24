import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/static/restaurant_search_result_state.dart';
import 'package:flutter_restaurant_app/data/api/api_services.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiServices apiServices;

  RestaurantSearchProvider(this.apiServices);

  RestaurantSearchResultState _state = RestaurantSearchNoneState();
  RestaurantSearchResultState get state => _state;

  Timer? _debounce;

  Future<void> search(String query) async {
    // Cancel previous debounce
    _debounce?.cancel();

    if (query.isEmpty) {
      _state = RestaurantSearchNoneState();
      notifyListeners();
      return;
    }

    // Start debounce
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        _state = RestaurantSearchLoadingState();
        notifyListeners();

        final result = await apiServices.searchRestaurant(query);

        _state = RestaurantSearchLoadedState(result.restaurants);
      } catch (e) {
        _state = RestaurantSearchErrorState(e.toString());
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
