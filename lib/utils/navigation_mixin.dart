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
      case 2:
        return '/orders';
      case 3:
      case 4:
        return '/products';
      case 5:
      case 6:
        return '/categories';
      case 7:
      case 8:
        return '/advertisements';
      case 9:
        return '/notifications';
      case 10:
      case 11:
      case 12:
        return '/profile';
      default:
        return '/dashboard';
    }
  }

  /// Handles a drawer item tap by replacing the current route.
  void onDrawerItemTapped(int index) {
    Navigator.pushReplacementNamed(context, indexToRoute(index));
  }
}
