import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/order_bloc.dart';
import '../../events/order_events.dart';
import '../../states/order_state.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderDetail(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          // Find the specific order from the list
          final orderData = state.orderList?.data?.firstWhere(
            (o) => o.orderId == widget.orderId,
            orElse: () => state.orderList!.data!.first,
          );

          if (orderData == null) {
            return const Center(child: Text('Order not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Order ID'),
                  subtitle: Text(orderData.orderId?.toString() ?? 'N/A'),
                ),
              ),
              if (orderData.product != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Product',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Name'),
                        subtitle: Text(orderData.product!.name ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Category'),
                        subtitle: Text(orderData.product!.category ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Weight (g)'),
                        subtitle: Text(orderData.product!.weightInGram ?? 'N/A'),
                      ),
                    ],
                  ),
                ),
              ],
              if (orderData.customer != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Customer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Name'),
                        subtitle: Text(orderData.customer!.name ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Phone'),
                        subtitle: Text(orderData.customer!.phone ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Email'),
                        subtitle: Text(orderData.customer!.email ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Address'),
                        subtitle: Text(orderData.customer!.address ?? 'N/A'),
                      ),
                    ],
                  ),
                ),
              ],
              if (orderData.pricing != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Pricing',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Quantity'),
                        subtitle: Text(orderData.pricing!.quantity ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Sub Total'),
                        subtitle: Text(orderData.pricing!.subTotal ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Shipping Cost'),
                        subtitle: Text(orderData.pricing!.shippingCost ?? 'N/A'),
                      ),
                      ListTile(
                        title: const Text('Total Price'),
                        subtitle: Text(orderData.pricing!.totalPrice ?? 'N/A'),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<OrderBloc>().add(DeleteOrder(widget.orderId));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Order'),
              ),
            ],
          );
        },
      ),
    );
  }
}
