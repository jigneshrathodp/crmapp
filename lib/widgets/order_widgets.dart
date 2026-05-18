import 'package:flutter/material.dart';
import '../models/Order_model/GetOrderModel.dart';

class OrderListWidget extends StatelessWidget {
  final List<Data> orders;
  final VoidCallback onRefresh;
  final Function(int) onDelete;
  // Navigate to OrderDetailScreen when tapping an item
  final Function(Data) onTap;

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
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () => onTap(order),
              leading: const Icon(Icons.shopping_cart),
              title: Text('Order #${order.orderId ?? 'N/A'}'),
              subtitle: Text('Customer: ${order.customer?.name ?? 'N/A'}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Order'),
                      content: const Text(
                          'Are you sure you want to delete this order?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(order.orderId!);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
