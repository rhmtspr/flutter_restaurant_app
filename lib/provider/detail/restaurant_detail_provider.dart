// todo-03-detail-01: create a new provider to handle a detail api
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant_app/data/api/api_services.dart';
import 'package:flutter_restaurant_app/static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  // todo-03-detail-02: inject an ApiService to maintain more easily
  final ApiServices _apiServices;

  RestaurantDetailProvider(this._apiServices);

  // todo-03-detail-03: add a variable state and get method
  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();

  RestaurantDetailResultState get resultState => _resultState;

  // todo-03-detail-04: create a function to load a detail page
  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();

      final result = await _apiServices.getRestaurantDetail(id);

      if (result.error) {
        _resultState = RestaurantDetailErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurantDetail);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}
