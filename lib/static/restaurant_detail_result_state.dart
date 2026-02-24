// todo-01-state-03: create a sealed class to make a state
import 'package:flutter_restaurant_app/data/model/restaurant_detail_model.dart';

sealed class RestaurantDetailResultState {}

// todo-01-state-04: expand the result for non, loading, loaded, and error state
class RestaurantDetailNoneState extends RestaurantDetailResultState {}

class RestaurantDetailLoadingState extends RestaurantDetailResultState {}

class RestaurantDetailErrorState extends RestaurantDetailResultState {
  final String error;

  RestaurantDetailErrorState(this.error);
}

class RestaurantDetailLoadedState extends RestaurantDetailResultState {
  final RestaurantDetail data;

  RestaurantDetailLoadedState(this.data);
}
