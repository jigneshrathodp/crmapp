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

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _quantityController = TextEditingController();
  final _shippingCostController = TextEditingController();
  final _emailController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  @override
  void dispose() {
    _productIdController.dispose();
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _customerAddressController.dispose();
    _quantityController.dispose();
    _shippingCostController.dispose();
    _emailController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<OrderBloc>().add(
        CreateOrder({
          'product_id': int.tryParse(_productIdController.text) ?? 0,
          'customer_name': _customerNameController.text,
          'phone_number': _phoneNumberController.text,
          'customer_address': _customerAddressController.text,
          'quantity': int.tryParse(_quantityController.text) ?? 1,
          'shipping_cost': double.tryParse(_shippingCostController.text) ?? 0,
          'email': _emailController.text,
          'selling_price_per_gram': _sellingPriceController.text,
        }),
      );
      // Let BlocListener handle snackbar and navigation.
    }
  }

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.black26),
  );
  static const _focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.black87, width: 1.5),
  );

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _focusBorder,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Create Order',
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
        headerSubtitle: 'Create Order',
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdOrder != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order created successfully'),
                backgroundColor: Colors.black87,
              ),
            );
            Navigator.pop(context);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.black87,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 4),
                TextFormField(
                  controller: _productIdController,
                  decoration: _dec('Product ID'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Product ID is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _customerNameController,
                  decoration: _dec('Customer Name'),
                  validator: (v) => v?.isEmpty ?? true ? 'Customer Name is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: _dec('Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v?.isEmpty ?? true ? 'Phone Number is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _customerAddressController,
                  decoration: _dec('Customer Address'),
                  validator: (v) => v?.isEmpty ?? true ? 'Address is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityController,
                  decoration: _dec('Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Quantity is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shippingCostController,
                  decoration: _dec('Shipping Cost'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Shipping Cost is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: _dec('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v?.isEmpty ?? true ? 'Email is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sellingPriceController,
                  decoration: _dec('Selling Price Per Gram'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Selling Price is required' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Create', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
