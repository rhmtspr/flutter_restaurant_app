// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant_app/data/model/restaurant.dart';
// import 'package:flutter_restaurant_app/provider/detail/bookmark_icon_provider.dart';
// import 'package:flutter_restaurant_app/provider/detail/bookmark_list_provider.dart';
// import 'package:provider/provider.dart';

// class BookmarkIconWidget extends StatefulWidget {
//   final Tourism tourism;

//   const BookmarkIconWidget({super.key, required this.tourism});

//   @override
//   State<BookmarkIconWidget> createState() => _BookmarkIconWidgetState();
// }

// class _BookmarkIconWidgetState extends State<BookmarkIconWidget> {
//   @override
//   void initState() {
//     final bookmarkListProvider = context.read<BookmarkListProvider>();
//     final bookmarkIconProvider = context.read<BookmarkIconProvider>();

//     Future.microtask(() {
//       final tourismInList = bookmarkListProvider.checkItemBookmark(
//         widget.tourism,
//       );
//       bookmarkIconProvider.isBookmarked = tourismInList;
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         final bookmarkListProvider = context.read<BookmarkListProvider>();
//         final bookmarkIconProvider = context.read<BookmarkIconProvider>();
//         final isBookmarked = bookmarkIconProvider.isBookmarked;

//         if (isBookmarked) {
//           bookmarkListProvider.removeBookmark(widget.tourism);
//         } else {
//           bookmarkListProvider.addBookmark(widget.tourism);
//         }
//         bookmarkIconProvider.isBookmarked = !isBookmarked;
//       },
//       icon: Icon(
//         context.watch<BookmarkIconProvider>().isBookmarked
//             ? Icons.bookmark
//             : Icons.bookmark_outline,
//       ),
//     );
//   }
// }
