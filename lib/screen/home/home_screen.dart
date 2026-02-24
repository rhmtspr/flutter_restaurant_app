import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:flutter_restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:flutter_restaurant_app/screen/search/search_screen.dart';
import 'package:flutter_restaurant_app/static/navigation_route.dart';
import 'package:flutter_restaurant_app/static/restaurant_list_result_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _fetch() async {
    await context.read<RestaurantListProvider>().fetchRestaurantList();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetch);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: "Search",
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            /// LOADING
            RestaurantListLoadingState() => const _LoadingView(),

            /// SUCCESS
            RestaurantListLoadedState(data: var restaurants) =>
              RefreshIndicator(
                onRefresh: _fetch,
                child: restaurants.isEmpty
                    ? const _EmptyView()
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 8),

                          /// Section header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              "Discover restaurants",
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          /// List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant = restaurants[index];

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

                          const SizedBox(height: 24),
                        ],
                      ),
              ),

            /// ERROR
            RestaurantListErrorState(error: var message) => _ErrorView(
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 48, color: colors.outline),
            const SizedBox(height: 12),
            Text("No restaurants found", style: text.titleMedium),
            const SizedBox(height: 6),
            Text(
              "Try refreshing or search something else",
              style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
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
