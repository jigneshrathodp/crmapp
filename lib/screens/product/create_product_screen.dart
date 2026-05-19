import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../bloc/product_bloc.dart';
import '../../events/product_events.dart';
import '../../states/product_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/navigation_mixin.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product image'), backgroundColor: Colors.black87),
      );
      return;
    }
    final imageFile = await http.MultipartFile.fromPath('image', _selectedImage!.path);
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
    if (_sellPriceController.text.isNotEmpty) fields['sell_price'] = _sellPriceController.text;
    context.read<ProductBloc>().add(CreateProduct(fields, imageFile: imageFile));
    // Let BlocListener handle snackbar and navigation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Create Product',
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
        selectedIndex: 3,
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Create Product',
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdProduct != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product created successfully'), backgroundColor: Colors.black87),
            );
            Navigator.pop(context);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}'), backgroundColor: Colors.black87),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 48, color: Colors.black38),
                              SizedBox(height: 8),
                              Text('Tap to select image (required)', style: TextStyle(color: Colors.black45)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(controller: _nameController, decoration: _dec('Name'),
                    validator: (v) => v?.isEmpty ?? true ? 'Name is required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _categoryController, decoration: _dec('Category ID'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Category ID is required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _qntyController, decoration: _dec('Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Quantity is required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _weightInGramController, decoration: _dec('Weight (gram)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Weight is required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _costPerGramController, decoration: _dec('Cost per Gram'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Cost per gram is required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _sellPriceController, decoration: _dec('Sell Price (optional)'),
                    keyboardType: TextInputType.number),
                SwitchListTile(title: const Text('Active'), value: _isActive,
                    activeThumbColor: Colors.black87, onChanged: (v) => setState(() => _isActive = v)),
                SwitchListTile(title: const Text('For Sale'), value: _forSale,
                    activeThumbColor: Colors.black87, onChanged: (v) => setState(() => _forSale = v)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87, foregroundColor: Colors.white,
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
