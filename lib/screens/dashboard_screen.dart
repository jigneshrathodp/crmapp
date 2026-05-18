import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../events/dashboard_events.dart';
import '../states/dashboard_state.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../utils/navigation_mixin.dart';
import 'notification_screen.dart';
import 'profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetDashboard());
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
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Dashboard',
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<DashboardBloc>().add(GetDashboard()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.dashboardData == null) {
            return const Center(child: Text('No data available'));
          }

          final data = state.dashboardData!;

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<DashboardBloc>().add(GetDashboard()),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade600,
                          Colors.deepPurple.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'CRM Dashboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.dashboard_rounded,
                          color: Colors.white30,
                          size: 56,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats heading
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Stats Grid - dynamic from API
                  _buildStatsGrid(data),

                  const SizedBox(height: 20),

                  // Additional data if present
                  if (data.containsKey('recent_orders') &&
                      data['recent_orders'] != null)
                    _buildRecentOrders(data['recent_orders']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> data) {
    // Build stat cards from known API fields
    final List<_StatItem> stats = [];

    if (data.containsKey('total_categories')) {
      stats.add(_StatItem(
        label: 'Total Categories',
        value: '${data['total_categories'] ?? 0}',
        icon: Icons.category_rounded,
        color: Colors.blue,
      ));
    }

    if (data.containsKey('total_products')) {
      stats.add(_StatItem(
        label: 'Total Products',
        value: '${data['total_products'] ?? 0}',
        icon: Icons.inventory_2_rounded,
        color: Colors.green,
      ));
    }

    if (data.containsKey('total_orders')) {
      stats.add(_StatItem(
        label: 'Total Orders',
        value: '${data['total_orders'] ?? 0}',
        icon: Icons.shopping_cart_rounded,
        color: Colors.orange,
      ));
    }

    if (data.containsKey('total_advertises') ||
        data.containsKey('total_ads')) {
      stats.add(_StatItem(
        label: 'Advertisements',
        value:
            '${data['total_advertises'] ?? data['total_ads'] ?? 0}',
        icon: Icons.campaign_rounded,
        color: Colors.purple,
      ));
    }

    if (data.containsKey('total_revenue')) {
      stats.add(_StatItem(
        label: 'Total Revenue',
        value: '₹${data['total_revenue'] ?? 0}',
        icon: Icons.currency_rupee_rounded,
        color: Colors.teal,
      ));
    }

    if (data.containsKey('total_customers')) {
      stats.add(_StatItem(
        label: 'Customers',
        value: '${data['total_customers'] ?? 0}',
        icon: Icons.people_rounded,
        color: Colors.indigo,
      ));
    }

    // If no known keys, display raw data as key-value chips
    if (stats.isEmpty) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: data.entries.map((e) {
          return _buildRawStatCard(
            e.key.replaceAll('_', ' ').toUpperCase(),
            '${e.value ?? 'N/A'}',
          );
        }).toList(),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: stats.map((s) => _buildStatCard(s)).toList(),
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: item.color.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: item.color.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                ),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRawStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(dynamic orders) {
    if (orders is! List || orders.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Orders',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        ...orders.take(5).map((o) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade50,
                child:
                    Icon(Icons.shopping_cart, color: Colors.orange.shade400),
              ),
              title: Text(
                'Order #${o['order_id'] ?? o['id'] ?? 'N/A'}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                o['customer']?['name'] ?? o['customer_name'] ?? 'N/A',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Text(
                '₹${o['pricing']?['total_price'] ?? o['total'] ?? 'N/A'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
