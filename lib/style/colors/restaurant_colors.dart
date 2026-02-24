import 'package:flutter/material.dart';

enum RestaurantColors {
  red("Red", Color(0xffBF124D));

  const RestaurantColors(this.name, this.color);

  final String name;
  final Color color;
}
