import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restaurant_app/static/restaurant_search_result_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantSearchProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Search Restaurant")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Cari restoran...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<RestaurantSearchProvider>().search(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (provider.state) {
                RestaurantSearchLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),

                RestaurantSearchErrorState(error: var error) => Center(
                  child: Text(error),
                ),

                RestaurantSearchNoneState() => const Center(
                  child: Text("Cari restoran"),
                ),

                RestaurantSearchLoadedState(data: var data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final restaurant = data[index];
                    return ListTile(
                      title: Text(restaurant.name),
                      subtitle: Text(restaurant.city),
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
