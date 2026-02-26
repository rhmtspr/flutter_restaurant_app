import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/api/api_services.dart';
import 'package:flutter_restaurant_app/data/local/local_database_service.dart';
import 'package:flutter_restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:flutter_restaurant_app/provider/detail/review_provider.dart';
import 'package:flutter_restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:flutter_restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:flutter_restaurant_app/provider/main/index_nav_provider.dart';
import 'package:flutter_restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:flutter_restaurant_app/screen/detail/detail_screen.dart';
import 'package:flutter_restaurant_app/screen/main/main_screen.dart';
import 'package:flutter_restaurant_app/static/navigation_route.dart';
import 'package:flutter_restaurant_app/style/theme/restaurant_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        Provider(create: (context) => ApiServices()),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantSearchProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(context.read<ApiServices>()),
        ),
        Provider(create: (context) => LocalDatabaseService()),
        ChangeNotifierProvider(
          create: (context) =>
              LocalDatabaseProvider(context.read<LocalDatabaseService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: RestaurantTheme.lightTheme,
      darkTheme: RestaurantTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
          restaurantId: ModalRoute.of(context)?.settings.arguments as String,
        ),
      },
    );
  }
}
