import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:flutter_restaurant_app/provider/detail/review_provider.dart';
import 'package:provider/provider.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  final RestaurantDetail restaurantDetail;

  const BodyOfDetailScreenWidget({super.key, required this.restaurantDetail});

  @override
  State<BodyOfDetailScreenWidget> createState() =>
      _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  late TextEditingController nameController;
  late TextEditingController reviewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    reviewController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foods = widget.restaurantDetail.menus.foods;
    final drinks = widget.restaurantDetail.menus.drinks;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Hero(
            tag: widget.restaurantDetail.pictureId,
            child: Image.network(
              "https://restaurant-api.dicoding.dev/images/large/${widget.restaurantDetail.pictureId}",
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 220,
                child: Center(child: Icon(Icons.broken_image)),
              ),
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
                        widget.restaurantDetail.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          widget.restaurantDetail.rating.toString(),
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
                        "${widget.restaurantDetail.city}, ${widget.restaurantDetail.address}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// DESCRIPTION
                Text(
                  widget.restaurantDetail.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),
                const SizedBox(height: 24),
                Text(
                  "Customer Reviews",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 12),

                Column(
                  children: widget.restaurantDetail.customerReviews.map((
                    review,
                  ) {
                    return ListTile(
                      title: Text(review.name),
                      subtitle: Text(review.review),
                      trailing: Text(review.date),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Review",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    context.read<ReviewProvider>().submitReview(
                      id: widget.restaurantDetail.id,
                      name: nameController.text,
                      review: reviewController.text,
                      onSuccess: (updatedReviews) {
                        // Refresh UI
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Review berhasil dikirim"),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text("Kirim Review"),
                ),
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
