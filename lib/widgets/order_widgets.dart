import 'package:flutter/material.dart';
import '../models/Order_model/GetOrderModel.dart';

class OrderListWidget extends StatelessWidget {
  final List<Data> orders;
  final VoidCallback onRefresh;
  final Function(int) onDelete;
  final Function(Data) onTap; // Navigate to Order Detail

  const OrderListWidget({
    super.key,
    required this.orders,
    required this.onRefresh,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(
            index: index,
            order: order,
            onDelete: onDelete,
            onViewDetail: onTap,
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final int index;
  final Data order;
  final Function(int) onDelete;
  final Function(Data) onViewDetail;

  const _OrderCard({
    required this.index,
    required this.order,
    required this.onDelete,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Serial No
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Product Image / Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (order.product?.image != null &&
                      order.product!.image!.isNotEmpty)
                  ? Image.network(
                      order.product!.image!,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _cartIcon(),
                    )
                  : _cartIcon(),
            ),
            const SizedBox(width: 12),

            // Order Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Order #${order.orderId ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Product section
                  if (order.product != null) ...[
                    Text(
                      'Product: ${order.product!.name ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _infoRow(Icons.category_outlined, 'Category',
                        order.product!.category ?? 'N/A'),
                    _infoRow(Icons.monitor_weight_outlined, 'Weight',
                        '${order.product!.weightInGram ?? 'N/A'} g'),
                  ],

                  // Customer section
                  if (order.customer != null) ...[
                    const SizedBox(height: 4),
                    _infoRow(Icons.person_outline, 'Customer',
                        order.customer!.name ?? 'N/A'),
                    _infoRow(Icons.phone_outlined, 'Phone',
                        order.customer!.phone ?? 'N/A'),
                    _infoRow(Icons.email_outlined, 'Email',
                        order.customer!.email ?? 'N/A'),
                    _infoRow(Icons.location_on_outlined, 'Address',
                        order.customer!.address ?? 'N/A'),
                  ],

                  // Pricing section
                  if (order.pricing != null) ...[
                    const SizedBox(height: 4),
                    const Divider(height: 10),
                    Row(
                      children: [
                        _priceBadge('Qty', order.pricing!.quantity ?? 'N/A',
                            Colors.blue),
                        const SizedBox(width: 6),
                        _priceBadge('SubTotal',
                            order.pricing!.subTotal ?? 'N/A', Colors.orange),
                        const SizedBox(width: 6),
                        _priceBadge('Total',
                            order.pricing!.totalPrice ?? 'N/A', Colors.green),
                      ],
                    ),
                    const SizedBox(height: 3),
                    _infoRow(Icons.local_shipping_outlined, 'Shipping',
                        order.pricing!.shippingCost ?? 'N/A'),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action Buttons
            Column(
              children: [
                // View Detail button
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () => onViewDetail(order),
                    icon: const Icon(Icons.visibility, size: 13),
                    label: const Text('Detail', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Delete button
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete, size: 13),
                    label: const Text('Delete', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 9, color: color, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _cartIcon() {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.shopping_cart_outlined,
          color: Colors.orange.shade300, size: 30),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Order'),
        content:
            Text('Are you sure you want to delete Order #${order.orderId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete(order.orderId!);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
