import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/order_bloc.dart';
import '../../events/order_events.dart';
import '../../states/order_state.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _customerNameController = TextEditingController();
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
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdOrder != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order created successfully')),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Padding(
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
      ),
    );
  }
}
