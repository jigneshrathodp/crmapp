import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'category_screen.dart';
import 'product_screen.dart';
import 'order_screen.dart';
import 'advertise_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onDrawerItemTapped(int index) {
    switch (index) {
      case 0: // Dashboard - already here
        break;
      case 1: // Order Now
      case 2: // Order List
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrderScreen()),
        );
        break;
      case 3: // Product List
      case 4: // Create Product
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductScreen()),
        );
        break;
      case 5: // Category List
      case 6: // Create Category
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoryScreen()),
        );
        break;
      case 7: // Ad List
      case 8: // Create Ad
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdvertiseScreen()),
        );
        break;
      case 9: // Notifications
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        );
        break;
      case 10: // Profile
      case 11: // Edit Profile
      case 12: // Change Password
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Dashboard',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        ),
        onProfilePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
      ),
      drawer: CustomDrawer(
        selectedIndex: 0,
        onItemTapped: _onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Dashboard',
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            context,
            'Categories',
            Icons.category_rounded,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoryScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            'Products',
            Icons.inventory_2_rounded,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            'Orders',
            Icons.shopping_cart_rounded,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            'Advertisements',
            Icons.campaign_rounded,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdvertiseScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
