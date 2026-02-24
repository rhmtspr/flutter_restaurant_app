import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail_model.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  const BodyOfDetailScreenWidget({super.key, required this.restaurantDetail});

  final RestaurantDetail restaurantDetail;

  @override
  Widget build(BuildContext context) {
    final foods = restaurantDetail.menus.foods;
    final drinks = restaurantDetail.menus.drinks;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Image.network(
            "https://restaurant-api.dicoding.dev/images/large/${restaurantDetail.pictureId}",
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(
              height: 220,
              child: Center(child: Icon(Icons.broken_image)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + RATING
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        restaurantDetail.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          restaurantDetail.rating.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// CITY + ADDRESS
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${restaurantDetail.city}, ${restaurantDetail.address}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// DESCRIPTION
                Text(
                  restaurantDetail.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),
                const Divider(),

                /// FOODS SECTION
                Text("Foods", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: foods
                      .map(
                        (food) => Chip(
                          label: Text(food.name),
                          avatar: const Icon(Icons.restaurant_menu, size: 18),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 24),

                /// DRINKS SECTION
                Text("Drinks", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: drinks
                      .map(
                        (drink) => Chip(
                          label: Text(drink.name),
                          avatar: const Icon(Icons.local_drink, size: 18),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
