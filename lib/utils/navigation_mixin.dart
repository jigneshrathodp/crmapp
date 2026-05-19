import 'package:flutter/material.dart';

/// A mixin that provides shared drawer navigation logic.
/// Mix this into any [State] class whose screen has a [CustomDrawer].
mixin DrawerNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Maps a drawer item index to a named route.
  String indexToRoute(int index) {
    switch (index) {
      case 0:
        return '/dashboard';
      case 1:
        return '/create-order';
      case 2:
        return '/orders';
      case 3:
        return '/products';
      case 4:
        return '/create-product';
      case 5:
        return '/categories';
      case 6:
        return '/create-category';
      case 7:
        return '/advertisements';
      case 8:
        return '/create-ad';
      case 9:
        return '/notifications';
      case 10:
        return '/profile';
      case 11:
        return '/edit-profile';
      case 12:
        return '/change-password';
      default:
        return '/dashboard';
    }
  }

  /// Handles a drawer item tap by replacing the current route.
  void onDrawerItemTapped(int index) {
    Navigator.pushReplacementNamed(context, indexToRoute(index));
  }
}
