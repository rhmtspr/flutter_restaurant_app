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
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final foods = widget.restaurantDetail.menus.foods;
    final drinks = widget.restaurantDetail.menus.drinks;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HERO IMAGE
          Stack(
            children: [
              Hero(
                tag: widget.restaurantDetail.pictureId,
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/large/${widget.restaurantDetail.pictureId}",
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),

              /// Gradient overlay
              Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colors.surface.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE + RATING
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.restaurantDetail.name,
                        style: text.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.restaurantDetail.rating.toString(),
                            style: text.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// ADDRESS
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${widget.restaurantDetail.city}, ${widget.restaurantDetail.address}",
                        style: text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// DESCRIPTION
                Text(
                  widget.restaurantDetail.description,
                  style: text.bodyMedium?.copyWith(height: 1.6),
                ),

                const SizedBox(height: 28),

                /// MENU SECTION
                _SectionTitle(title: "Foods"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: foods.map((food) {
                    return Chip(
                      label: Text(food.name),
                      backgroundColor: colors.surfaceVariant,
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                _SectionTitle(title: "Drinks"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: drinks.map((drink) {
                    return Chip(
                      label: Text(drink.name),
                      backgroundColor: colors.surfaceVariant,
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                /// REVIEWS
                _SectionTitle(title: "Customer Reviews"),
                const SizedBox(height: 16),

                Column(
                  children: widget.restaurantDetail.customerReviews.map((
                    review,
                  ) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.name,
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(review.review, style: text.bodyMedium),
                          const SizedBox(height: 8),
                          Text(
                            review.date,
                            style: text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                _SectionTitle(title: "Write a Review"),
                const SizedBox(height: 12),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Your name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Share your experience...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                Consumer<ReviewProvider>(
                  builder: (context, reviewProvider, _) {
                    final state = reviewProvider.state;

                    if (state is ReviewLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton(
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
                        child: const Text("Submit Review"),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
