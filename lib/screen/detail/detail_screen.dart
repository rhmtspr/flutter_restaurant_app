import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/provider/detail/bookmark_icon_provider.dart';
import 'package:flutter_restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:flutter_restaurant_app/screen/detail/body_of_detail_screen_widget.dart';
// ignore: unused_import
import 'package:flutter_restaurant_app/screen/detail/bookmark_icon_widget.dart';
import 'package:flutter_restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // todo-03-detail-08: we dont need this anymore
  // final Completer<Tourism> _completerTourism = Completer<Tourism>();
  // late Future<TourismDetailResponse> _futureTourismDetail;

  @override
  void initState() {
    super.initState();

    // todo-03-detail-05: you can change this action using provider
    // _futureTourismDetail = ApiServices().getTourismDetail(widget.tourism.id);
    Future.microtask(() {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurantId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tourism Detail"),
        actions: [
          ChangeNotifierProvider(
            create: (context) => BookmarkIconProvider(),
            // todo-03-detail-06: change this widget using Consumer
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantDetailLoadedState(data: var tourism) =>
                    BookmarkIconWidget(tourism: tourism),
                  _ => const SizedBox(),
                };
              },
            ),
          ),
        ],
      ),
      // todo-03-detail-07: change this widget using Consumer too
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantDetailLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantDetailLoadedState(data: var restaurantDetail) =>
              BodyOfDetailScreenWidget(restaurantDetail: restaurantDetail),
            RestaurantDetailErrorState(error: var message) => Center(
              child: Text(message),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
