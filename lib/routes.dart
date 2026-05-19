import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/change_password_screen.dart';

import 'screens/category/category_list_screen.dart';
import 'screens/category/create_category_screen.dart';
import 'screens/category/update_category_screen.dart';

import 'screens/product/product_list_screen.dart';
import 'screens/product/create_product_screen.dart';
import 'screens/product/update_product_screen.dart';

import 'screens/order/order_list_screen.dart';
import 'screens/order/create_order_screen.dart';
import 'screens/order/order_detail_screen.dart';

import 'screens/ads/ads_list_screen.dart';
import 'screens/ads/create_ads_screen.dart';
import 'screens/ads/update_ads_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  
  static const String notifications = '/notifications';

  static const String categories = '/categories';
  static const String createCategory = '/create-category';
  static const String updateCategory = '/update-category';

  static const String products = '/products';
  static const String createProduct = '/create-product';
  static const String updateProduct = '/update-product';

  static const String orders = '/orders';
  static const String createOrder = '/create-order';
  static const String orderDetail = '/order-detail';

  static const String advertisements = '/advertisements';
  static const String createAd = '/create-ad';
  static const String updateAd = '/update-ad';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoryListScreen());
      case createCategory:
        return MaterialPageRoute(builder: (_) => const CreateCategoryScreen());
      case updateCategory:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => UpdateCategoryScreen(
            categoryId: args['categoryId'] as int,
            categoryName: args['categoryName'] as String?,
            categorySku: args['categorySku'] as String?,
            categoryImage: args['categoryImage'] as String?,
          ),
        );

      case products:
        return MaterialPageRoute(builder: (_) => const ProductListScreen());
      case createProduct:
        return MaterialPageRoute(builder: (_) => const CreateProductScreen());
      case updateProduct:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => UpdateProductScreen(
            productId: args['productId'] as int,
            productName: args['productName'] as String?,
            productSku: args['productSku'] as String?,
            categoryId: args['categoryId'] as String?,
            quantity: args['quantity'] as String?,
            sellPrice: args['sellPrice'] as String?,
            weightInGram: args['weightInGram'] as String?,
            costPerGram: args['costPerGram'] as String?,
            totalCost: args['totalCost'] as String?,
            image: args['image'] as String?,
            active: args['active'] as int?,
            forSale: args['forSale'] as int?,
          ),
        );

      case orders:
        return MaterialPageRoute(builder: (_) => const OrderListScreen());
      case createOrder:
        return MaterialPageRoute(builder: (_) => const CreateOrderScreen());
      case orderDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(
            orderId: args['orderId'] as int,
          ),
        );

      case advertisements:
        return MaterialPageRoute(builder: (_) => const AdsListScreen());
      case createAd:
        return MaterialPageRoute(builder: (_) => const CreateAdsScreen());
      case updateAd:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => UpdateAdsScreen(
            advertiseId: args['advertiseId'] as int,
            advertiseTitle: args['advertiseTitle'] as String?,
            advertiseDate: args['advertiseDate'] as String?,
            advertisePrice: args['advertisePrice'] as String?,
            advertiseUrl: args['advertiseUrl'] as String?,
            advertiseSocialMedia: args['advertiseSocialMedia'] as String?,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
