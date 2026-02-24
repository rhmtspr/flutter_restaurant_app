import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:flutter_restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:flutter_restaurant_app/provider/detail/review_provider.dart';
import 'package:flutter_restaurant_app/static/review_result_state.dart';
import 'package:provider/provider.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  final RestaurantDetail restaurantDetail;

  const BodyOfDetailScreenWidget({super.key, required this.restaurantDetail});

  @override
  State<BodyOfDetailScreenWidget> createState() =>
      _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  bool _handledReviewState = false;
  late ReviewProvider _reviewProvider;
  late TextEditingController nameController;
  late TextEditingController reviewController;

  void _reviewListener() async {
    final state = _reviewProvider.state;

    if (!mounted) return;

    if (state is ReviewSuccessState && !_handledReviewState) {
      _handledReviewState = true;

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(content: Text("Review berhasil dikirim")),
      );

      await context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurantDetail.id,
      );

      if (!mounted) return;

      nameController.clear();

      reviewController.clear();

      _reviewProvider.resetState();
      _handledReviewState = false;
    }

    if (state is ReviewErrorState && !_handledReviewState) {
      _handledReviewState = true;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error)));

      _reviewProvider.resetState();
      _handledReviewState = false;
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    reviewController = TextEditingController();

    _reviewProvider = context.read<ReviewProvider>();
    _reviewProvider.addListener(_reviewListener);
  }

  @override
  void dispose() {
    _reviewProvider.removeListener(_reviewListener);
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

                Consumer<ReviewProvider>(
                  builder: (context, reviewProvider, _) {
                    final state = reviewProvider.state;

                    if (state is ReviewLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            reviewController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Nama dan review wajib diisi"),
                            ),
                          );
                          return;
                        }

                        await context.read<ReviewProvider>().submitReview(
                          id: widget.restaurantDetail.id,
                          name: nameController.text,
                          review: reviewController.text,
                        );
                      },
                      child: const Text("Kirim Review"),
                    );
                  },
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
