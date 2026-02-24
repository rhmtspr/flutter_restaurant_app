// todo-02-home-01: create a Restaurant list provider that contain a result state
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant_app/data/api/api_services.dart';
import 'package:flutter_restaurant_app/static/restaurant_list_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  // todo-02-home-02: inject an ApiService to maintain more easily
  final ApiServices _apiServices;

  RestaurantListProvider(this._apiServices);

  // todo-02-home-03: add result state to maintain the state and get method
  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  // todo-02-home-04: create a function to load the list
  Future<void> fetchRestaurantList() async {
    // todo-02-home-05: add a try-catch to maintain error
    try {
      // todo-02-home-06: first, initialize the loading state, dont forget to notify it
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      // todo-02-home-07: second, run the api service
      final result = await _apiServices.getRestaurantList();

      print("API RESULT: ${result.restaurants.length}");

      if (result.error) {
        _resultState = RestaurantListErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = RestaurantListLoadedState(result.restaurants);
        print(_resultState);
        notifyListeners();
      }
    } on Exception catch (e) {
      // todo-02-home-08: then, notify the widget when it's error
      _resultState = RestaurantListErrorState(e.toString());
      notifyListeners();
    }
  }
}
