import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../events/order_events.dart';
import '../states/order_state.dart';
import '../widgets/order_widgets.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'order_detail_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

// Convert to StatefulWidget to dispatch GetOrderList in initState
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderList());
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pushReplacementNamed(context, _indexToRoute(index));
  }

  String _indexToRoute(int index) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Orders',
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
        onItemTapped: _onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Orders',
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<OrderBloc>().add(GetOrderList()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.orderList?.data == null ||
              state.orderList!.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No orders found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<OrderBloc>().add(GetOrderList()),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return OrderListWidget(
            orders: state.orderList!.data!,
            onRefresh: () =>
                context.read<OrderBloc>().add(GetOrderList()),
            onDelete: (id) =>
                context.read<OrderBloc>().add(DeleteOrder(id)),
            // Navigate to OrderDetailScreen on tap, reload list on return
            onTap: (order) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderDetailScreen(orderId: order.orderId!),
                ),
              ).then((_) => context.read<OrderBloc>().add(GetOrderList()));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateOrderScreen(),
            ),
          ).then((_) => context.read<OrderBloc>().add(GetOrderList()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _customerNameController = TextEditingController();
  // Fixed: API field is 'phone_number', not 'customer_phone'
  final _phoneNumberController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _quantityController = TextEditingController();
  final _shippingCostController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _productIdController.dispose();
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _customerAddressController.dispose();
    _quantityController.dispose();
    _shippingCostController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<OrderBloc>().add(
        CreateOrder({
          'product_id': int.tryParse(_productIdController.text) ?? 0,
          'customer_name': _customerNameController.text,
          // Fixed: correct API field names
          'phone_number': _phoneNumberController.text,
          'customer_address': _customerAddressController.text,
          'quantity': int.tryParse(_quantityController.text) ?? 1,
          'shipping_cost': double.tryParse(_shippingCostController.text) ?? 0,
          'email': _emailController.text,
        }),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _productIdController,
                decoration: const InputDecoration(labelText: 'Product ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Product ID is required' : null,
              ),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Customer Name is required' : null,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Phone Number is required' : null,
              ),
              TextFormField(
                controller: _customerAddressController,
                decoration: const InputDecoration(labelText: 'Customer Address'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Address is required' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Quantity is required' : null,
              ),
              TextFormField(
                controller: _shippingCostController,
                decoration: const InputDecoration(labelText: 'Shipping Cost'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Shipping Cost is required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email is required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text('Create')),
            ],
          ),
        ),
      ),
    );
  }
}
