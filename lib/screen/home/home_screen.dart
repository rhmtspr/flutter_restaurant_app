import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:flutter_restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:flutter_restaurant_app/static/navigation_route.dart';
import 'package:flutter_restaurant_app/static/restaurant_list_result_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // todo-02-home-13: we dont need this anymore
  // late Future<TourismListResponse> _futureTourismResponse;

  @override
  void initState() {
    super.initState();
    // todo-02-home-13: we dont need this anymore
    // _futureTourismResponse = ApiServices().getTourismList();
    // todo-02-home-09: load the api using Provider
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant List")),
      // todo-02-home-10: comment this code below
      // todo-02-home-11: add a Consumer to maintain the result state
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          // todo-02-home-12: use sealed class to define a various state
          return switch (value.resultState) {
            RestaurantListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantListLoadedState(data: var restaurantList) =>
              ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];

                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant.id,
                      );
                    },
                  );
                },
              ),
            RestaurantListErrorState(error: var message) => Center(
              child: Text(message),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
