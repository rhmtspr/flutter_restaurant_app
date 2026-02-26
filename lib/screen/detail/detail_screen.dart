import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_model.dart';
import 'package:flutter_restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:flutter_restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:flutter_restaurant_app/screen/detail/body_of_detail_screen_widget.dart';
import 'package:flutter_restaurant_app/screen/detail/favorite_icon_widget.dart';
import 'package:flutter_restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Restaurant toRestaurant(RestaurantDetail detail) {
    return Restaurant(
      id: detail.id,
      name: detail.name,
      description: detail.description,
      city: detail.city,
      pictureId: detail.pictureId,
      rating: detail.rating,
    );
  }

  Future<void> _fetch() async {
    await context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
      widget.restaurantId,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant"),
        centerTitle: false,
        actions: [
          ChangeNotifierProvider(
            create: (context) => FavoriteIconProvider(),
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantDetailLoadedState(data: var restaurant) =>
                    FavoriteIconWidget(restaurant: toRestaurant(restaurant)),
                  _ => const SizedBox(),
                };
              },
            ),
          ),
        ],
      ),

      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantDetailLoadingState() => const _LoadingView(),

            RestaurantDetailLoadedState(data: var restaurant) =>
              BodyOfDetailScreenWidget(restaurantDetail: restaurant),

            RestaurantDetailErrorState(error: var message) => _ErrorView(
              message: message,
              onRetry: _fetch,
            ),

            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text("Try again")),
          ],
        ),
      ),
    );
  }
}
