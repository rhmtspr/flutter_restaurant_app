import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/api/api_services.dart';
// ignore: unused_import
import 'package:flutter_restaurant_app/data/model/customer_review.dart';
import 'package:flutter_restaurant_app/static/review_result_state.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiServices api;

  ReviewProvider(this.api);

  ReviewResultState _state = ReviewNoneState();
  ReviewResultState get state => _state;

  Future<void> submitReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      _state = ReviewLoadingState();
      notifyListeners();

      await api.addReview(id: id, name: name, review: review);

      _state = ReviewSuccessState();
      notifyListeners();
    } catch (e) {
      _state = ReviewErrorState(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _state = ReviewNoneState();
    notifyListeners();
  }
}
