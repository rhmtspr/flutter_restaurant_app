class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json["name"] ?? "");
  }
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json["name"] ?? "");
  }
}

class Menu {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      foods: (json['foods'] as List<dynamic>? ?? [])
          .map((e) => MenuItem.fromJson(e))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>? ?? [])
          .map((e) => MenuItem.fromJson(e))
          .toList(),
    );
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final List<Category> categories;
  final Menu menus;
  final double rating;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
      menus: json['menus'] != null
          ? Menu.fromJson(json['menus'])
          : Menu(foods: [], drinks: []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      customerReviews: (json['customerReviews'] as List<dynamic>? ?? [])
          .map((e) => CustomerReview.fromJson(e))
          .toList(),
    );
  }
}
