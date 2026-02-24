import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:flutter_restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:flutter_restaurant_app/static/restaurant_search_result_state.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantSearchProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Search"), centerTitle: false),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// SEARCH FIELD
            TextField(
              decoration: InputDecoration(
                hintText: "Search restaurant...",
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: colors.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<RestaurantSearchProvider>().search(value);
              },
            ),

            const SizedBox(height: 20),

            /// RESULT SECTION
            Expanded(
              child: switch (provider.state) {
                /// LOADING
                RestaurantSearchLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),

                /// ERROR
                RestaurantSearchErrorState(error: var error) => _ErrorView(
                  message: error,
                ),

                /// NONE (INITIAL)
                RestaurantSearchNoneState() => _EmptySearchView(),

                /// LOADED
                RestaurantSearchLoadedState(data: var data) =>
                  data.isEmpty
                      ? const _NoResultView()
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final restaurant = data[index];

                            return RestaurantCard(
                              restaurant: restaurant,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/detail",
                                  arguments: restaurant.id,
                                );
                              },
                            );
                          },
                        ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 48, color: colors.outline),
          const SizedBox(height: 12),
          const Text("Start typing to search restaurants"),
        ],
      ),
    );
  }
}

class _NoResultView extends StatelessWidget {
  const _NoResultView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 48, color: colors.outline),
          const SizedBox(height: 12),
          const Text("No restaurants found"),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: colors.error),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
