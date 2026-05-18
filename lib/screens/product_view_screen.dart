import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../events/product_events.dart';
import '../states/product_state.dart';

class ProductViewScreen extends StatefulWidget {
  final int productId;
  final String? productName;
  final String? productSku;
  final String? categoryId;
  final String? quantity;
  final String? sellPrice;
  final String? weightInGram;
  final String? costPerGram;

  const ProductViewScreen({
    super.key,
    required this.productId,
    this.productName,
    this.productSku,
    this.categoryId,
    this.quantity,
    this.sellPrice,
    this.weightInGram,
    this.costPerGram,
  });

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _qntyController;
  late TextEditingController _weightInGramController;
  late TextEditingController _costPerGramController;
  late TextEditingController _sellPriceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productName ?? '');
    _categoryController = TextEditingController(text: widget.categoryId ?? '');
    _qntyController = TextEditingController(text: widget.quantity ?? '');
    _weightInGramController = TextEditingController(text: widget.weightInGram ?? '');
    _costPerGramController = TextEditingController(text: widget.costPerGram ?? '');
    _sellPriceController = TextEditingController(text: widget.sellPrice ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _qntyController.dispose();
    _weightInGramController.dispose();
    _costPerGramController.dispose();
    _sellPriceController.dispose();
    super.dispose();
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      context.read<ProductBloc>().add(
        UpdateProduct(widget.productId, {
          'name': _nameController.text,
          // Fixed: API uses 'category' and 'qnty', and requires _method: PUT
          'category': _categoryController.text,
          'qnty': _qntyController.text,
          'weight_in_gram': _weightInGramController.text,
          'cost_per_gram': _costPerGramController.text,
          if (_sellPriceController.text.isNotEmpty)
            'sell_price': _sellPriceController.text,
          '_method': 'PUT',
        }),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View/Update Product'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.updatedProduct != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product updated successfully')),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Category ID is required' : null,
                ),
                TextFormField(
                  controller: _qntyController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Quantity is required' : null,
                ),
                TextFormField(
                  controller: _weightInGramController,
                  decoration: const InputDecoration(labelText: 'Weight (gram)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Weight is required' : null,
                ),
                TextFormField(
                  controller: _costPerGramController,
                  decoration: const InputDecoration(labelText: 'Cost per Gram'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Cost per gram is required' : null,
                ),
                TextFormField(
                  controller: _sellPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Sell Price (optional)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProduct,
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
