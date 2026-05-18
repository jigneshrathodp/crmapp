import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../bloc/product_bloc.dart';
import '../../events/product_events.dart';
import '../../states/product_state.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _qntyController = TextEditingController();
  final _weightInGramController = TextEditingController();
  final _costPerGramController = TextEditingController();
  final _sellPriceController = TextEditingController();
  bool _isActive = true;
  bool _forSale = true;
  File? _selectedImage;
  final _picker = ImagePicker();

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

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a product image')),
        );
        return;
      }
      final imageFile = await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
      );
      if (!mounted) return;

      final fields = <String, String>{
        'name': _nameController.text,
        'category': _categoryController.text,
        'qnty': _qntyController.text,
        'weight_in_gram': _weightInGramController.text,
        'cost_per_gram': _costPerGramController.text,
        'sts': _isActive ? '1' : '0',
        'for_sale': _forSale ? '1' : '0',
      };
      if (_sellPriceController.text.isNotEmpty) {
        fields['sell_price'] = _sellPriceController.text;
      }

      context.read<ProductBloc>().add(
        CreateProduct(fields, imageFile: imageFile),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdProduct != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product created successfully')),
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
                // Image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate,
                                  size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to select image (required)',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 12),
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
      ),
    );
  }
}
