// todo-01-state-01: create a sealed class to make a state
import 'package:flutter_restaurant_app/data/model/restaurant.dart';

sealed class RestaurantListResultState {}

// todo-01-state-02: expand the result for none, loading, loaded, and error state
class RestaurantListNoneState extends RestaurantListResultState {}

class RestaurantListLoadingState extends RestaurantListResultState {}

class RestaurantListErrorState extends RestaurantListResultState {
  final String error;

  RestaurantListErrorState(this.error);
}

class RestaurantListLoadedState extends RestaurantListResultState {
  final List<Restaurant> data;

  RestaurantListLoadedState(this.data);
}
