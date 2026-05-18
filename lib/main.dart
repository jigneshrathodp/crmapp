import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api_url.dart';
import 'base_api/base_api.dart';
import 'all_api_calls/all_api_calls.dart';
import 'bloc/advertise_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/category_bloc.dart';
import 'bloc/dashboard_bloc.dart';
import 'bloc/notification_bloc.dart';
import 'bloc/order_bloc.dart';
import 'bloc/product_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/category/category_list_screen.dart';
import 'screens/product/product_list_screen.dart';
import 'screens/order/order_list_screen.dart';
import 'screens/ads/ads_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseApi = BaseApi(ApiUrls.baseUrl);
    final apiCalls = AllApiCalls(baseApi);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(apiCalls)),
        BlocProvider(create: (context) => DashboardBloc(apiCalls)),
        BlocProvider(create: (context) => CategoryBloc(apiCalls)),
        BlocProvider(create: (context) => ProductBloc(apiCalls)),
        BlocProvider(create: (context) => OrderBloc(apiCalls)),
        BlocProvider(create: (context) => AdvertiseBloc(apiCalls)),
        BlocProvider(create: (context) => ProfileBloc(apiCalls)),
        BlocProvider(create: (context) => NotificationBloc(apiCalls)),
      ],
      child: MaterialApp(
        title: 'CRM App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Fixed: was `.fromSeed(...)` missing the class name `ColorScheme`
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/categories': (context) => const CategoryListScreen(),
          '/products': (context) => const ProductListScreen(),
          '/orders': (context) => const OrderListScreen(),
          '/advertisements': (context) => const AdsListScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/notifications': (context) => const NotificationScreen(),
        },
      ),
    );
  }
}
