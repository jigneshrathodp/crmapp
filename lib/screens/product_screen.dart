import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../events/product_events.dart';
import '../states/product_state.dart';
import '../widgets/product_widgets.dart';
// Import view screen for navigation
import 'product_view_screen.dart';

// Convert to StatefulWidget to dispatch GetProductList in initState
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-load products when screen opens
    context.read<ProductBloc>().add(GetProductList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilder<ProductBloc, ProductState>(
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
                        context.read<ProductBloc>().add(GetProductList()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.productList?.data == null ||
              state.productList!.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No products found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductBloc>().add(GetProductList()),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return ProductListWidget(
            products: state.productList!.data!,
            onRefresh: () =>
                context.read<ProductBloc>().add(GetProductList()),
            onDelete: (id) =>
                context.read<ProductBloc>().add(DeleteProduct(id)),
            // Navigate to ProductViewScreen on tap, reload list on return
            onTap: (product) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductViewScreen(
                    productId: product.id!,
                    productName: product.name,
                    productSku: product.sku,
                    categoryId: product.categoryId,
                    quantity: product.quantity,
                    sellPrice: product.sellPrice,
                    weightInGram: product.weightInGram,
                    costPerGram: product.costPerGram,
                  ),
                ),
              ).then((_) => context.read<ProductBloc>().add(GetProductList()));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProductScreen(),
            ),
          ).then((_) => context.read<ProductBloc>().add(GetProductList()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  // Fixed: API field is 'category' (category ID), not 'category_id'
  final _categoryController = TextEditingController();
  // Fixed: API field is 'qnty', not 'quantity'
  final _qntyController = TextEditingController();
  final _weightInGramController = TextEditingController();
  final _costPerGramController = TextEditingController();
  final _sellPriceController = TextEditingController();
  // Fixed: API fields 'sts' (active status) and 'for_sale'
  bool _isActive = true;
  bool _forSale = true;

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProductBloc>().add(
        CreateProduct({
          'name': _nameController.text,
          // Fixed: correct API field names per Postman collection
          'category': _categoryController.text,
          'qnty': _qntyController.text,
          'weight_in_gram': _weightInGramController.text,
          'cost_per_gram': _costPerGramController.text,
          'sts': _isActive ? '1' : '0',
          'for_sale': _forSale ? '1' : '0',
          if (_sellPriceController.text.isNotEmpty)
            'sell_price': _sellPriceController.text,
        }),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Product')),
      body: Padding(
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
              SwitchListTile(
                title: const Text('Active'),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              SwitchListTile(
                title: const Text('For Sale'),
                value: _forSale,
                onChanged: (val) => setState(() => _forSale = val),
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
