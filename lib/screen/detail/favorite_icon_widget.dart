import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_model.dart';
import 'package:flutter_restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:flutter_restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:provider/provider.dart';

class FavoriteIconWidget extends StatefulWidget {
  final Restaurant restaurant;

  const FavoriteIconWidget({super.key, required this.restaurant});

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  @override
  void initState() {
    super.initState();
    // todo-03-action-02: change this provider using LocalDatabaseProvider
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final bookmarkIconProvider = context.read<FavoriteIconProvider>();

    Future.microtask(() async {
      // todo-03-action-03: change this action using LocalDatabaseProvider
      await localDatabaseProvider.loadRestaurantById(widget.restaurant.id);
      final value = localDatabaseProvider.checkItemFavorite(
        widget.restaurant.id,
      );
      bookmarkIconProvider.isFavorited = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // todo-03-action-04: change this action using LocalDatabaseProvider
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final bookmarkIconProvider = context.read<FavoriteIconProvider>();
        final isFavorited = bookmarkIconProvider.isFavorited;

        // todo-03-action-05: change this action using LocalDatabaseProvider
        if (isFavorited) {
          await localDatabaseProvider.removeRestaurantById(
            widget.restaurant.id,
          );
        } else {
          await localDatabaseProvider.saveRestaurant(widget.restaurant);
        }
        bookmarkIconProvider.isFavorited = !isFavorited;
        // todo-03-action-06: add this action to load the page
        localDatabaseProvider.loadAllRestaurant();
      },
      icon: Icon(
        context.watch<FavoriteIconProvider>().isFavorited
            ? Icons.favorite
            : Icons.favorite_border_outlined,
      ),
    );
  }
}
