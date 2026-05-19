import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../events/dashboard_events.dart';
import '../states/dashboard_state.dart';
import '../bloc/profile_bloc.dart';
import '../events/profile_events.dart';
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
    context.read<ProfileBloc>().add(GetProfileDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
            return const Center(
              child: CircularProgressIndicator(color: Colors.black87),
            );
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<DashboardBloc>().add(GetDashboard()),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                    ),
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
            color: Colors.black87,
            onRefresh: () async =>
                context.read<DashboardBloc>().add(GetDashboard()),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildStatsGrid(data)],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> data) {
    // The API returns: { status, message, data: { stats: {...}, profile, details, notifications } }
    // Extract the 'stats' sub-object. Support both direct-flat maps and wrapped responses.
    final Map<String, dynamic> statsMap = (data['stats'] is Map)
        ? Map<String, dynamic>.from(data['stats'] as Map)
        : data;

    final List<_StatItem> stats = [];

    if (statsMap.containsKey('total_categories')) {
      stats.add(
        _StatItem(
          label: 'Total Categories',
          value: '${statsMap['total_categories'] ?? 0}',
          icon: Icons.format_list_bulleted_rounded,
        ),
      );
    }

    if (statsMap.containsKey('total_products')) {
      stats.add(
        _StatItem(
          label: 'Total Products',
          value: '${statsMap['total_products'] ?? 0}',
          icon: Icons.inventory_2_rounded,
        ),
      );
    }

    if (statsMap.containsKey('total_sold_products')) {
      stats.add(
        _StatItem(
          label: 'Sold Products',
          value: '${statsMap['total_sold_products'] ?? 0}',
          icon: Icons.local_offer_rounded,
        ),
      );
    }

    if (statsMap.containsKey('total_orders')) {
      stats.add(
        _StatItem(
          label: 'Total Orders',
          value: '${statsMap['total_orders'] ?? 0}',
          icon: Icons.receipt_long_rounded,
        ),
      );
    }

    if (statsMap.containsKey('current_month_orders')) {
      stats.add(
        _StatItem(
          label: 'Current Month Orders',
          value: '${statsMap['current_month_orders'] ?? 0}',
          icon: Icons.calendar_month_rounded,
        ),
      );
    }

    if (statsMap.containsKey('total_product_cost')) {
      stats.add(
        _StatItem(
          label: 'Total Product Cost',
          value: '₹${statsMap['total_product_cost'] ?? 0}',
          icon: Icons.shopping_bag_rounded,
        ),
      );
    }

    if (statsMap.containsKey('total_sold_price')) {
      stats.add(
        _StatItem(
          label: 'Total Sold Price',
          value: '₹${statsMap['total_sold_price'] ?? 0}',
          icon: Icons.attach_money_rounded,
        ),
      );
    }

    if (statsMap.containsKey('total_advertisements')) {
      stats.add(
        _StatItem(
          label: 'Total Advertisements',
          value: '${statsMap['total_advertisements'] ?? 0}',
          icon: Icons.ad_units_rounded,
        ),
      );
    }

    if (statsMap.containsKey('total_advertise_price')) {
      stats.add(
        _StatItem(
          label: 'Total Advertise Price',
          value: '₹${statsMap['total_advertise_price'] ?? 0}',
          icon: Icons.receipt_rounded,
        ),
      );
    }

    // Fallback: show raw data if no known keys matched
    if (stats.isEmpty) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: statsMap.entries.map((e) {
          return _buildStatCard(
            _StatItem(
              label: e.key.replaceAll('_', ' ').toUpperCase(),
              value: '${e.value ?? 'N/A'}',
              icon: Icons.bar_chart_rounded,
            ),
          );
        }).toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 200).floor().clamp(1, 4);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (_, i) => _buildStatCard(stats[i]),
        );
      },
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: label + value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right side: black circle icon
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}
