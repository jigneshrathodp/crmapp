import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/order_bloc.dart';
import '../../events/order_events.dart';
import '../../states/order_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/navigation_mixin.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderDetail(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Order Detail',
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
        selectedIndex: 2,
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Order Detail',
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black87));
          }

          if (state.error != null) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.black54),
              ),
            );
          }

          // FIX: orderDetail is now ViewOrderModel with a single data object (not a list)
          final orderData = state.orderDetail?.data;

          if (orderData == null) {
            return const Center(
              child: Text(
                'Order not found',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionCard(
                title: 'Order Info',
                icon: Icons.receipt_long_rounded,
                children: [
                  _infoRow('Order ID', '#${orderData.orderId ?? 'N/A'}'),
                ],
              ),
              if (orderData.product != null) ...[
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Product',
                  icon: Icons.inventory_2_rounded,
                  children: [
                    _infoRow('Name', orderData.product!.name ?? 'N/A'),
                    _infoRow('Category', orderData.product!.category ?? 'N/A'),
                    _infoRow('Weight (g)', orderData.product!.weightInGram ?? 'N/A'),
                  ],
                ),
              ],
              if (orderData.customer != null) ...[
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Customer',
                  icon: Icons.person_rounded,
                  children: [
                    _infoRow('Name', orderData.customer!.name ?? 'N/A'),
                    _infoRow('Phone', orderData.customer!.phone ?? 'N/A'),
                    _infoRow('Email', orderData.customer!.email ?? 'N/A'),
                    _infoRow('Address', orderData.customer!.address ?? 'N/A'),
                  ],
                ),
              ],
              if (orderData.pricing != null) ...[
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Pricing',
                  icon: Icons.attach_money_rounded,
                  children: [
                    _infoRow('Quantity', orderData.pricing!.quantity ?? 'N/A'),
                    _infoRow('Sub Total', orderData.pricing!.subTotal ?? 'N/A'),
                    _infoRow('Shipping Cost', orderData.pricing!.shippingCost ?? 'N/A'),
                    _infoRow('Total Price', orderData.pricing!.totalPrice ?? 'N/A'),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<OrderBloc>().add(DeleteOrder(widget.orderId));
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Delete Order', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
