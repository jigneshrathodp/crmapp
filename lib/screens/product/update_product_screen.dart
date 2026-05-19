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

class UpdateProductScreen extends StatefulWidget {
  final int productId;
  final String? productName;
  final String? productSku;
  final String? categoryId;
  final String? quantity;
  final String? sellPrice;
  final String? weightInGram;
  final String? costPerGram;
  final String? totalCost;
  final String? image;
  final int? active;
  final int? forSale;

  const UpdateProductScreen({
    super.key,
    required this.productId,
    this.productName,
    this.productSku,
    this.categoryId,
    this.quantity,
    this.sellPrice,
    this.weightInGram,
    this.costPerGram,
    this.totalCost,
    this.image,
    this.active,
    this.forSale,
  });

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _qntyController;
  late TextEditingController _weightInGramController;
  late TextEditingController _costPerGramController;
  late TextEditingController _sellPriceController;
  late bool _isActive;
  late bool _forSale;
  File? _newImage;
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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productName ?? '');
    _categoryController = TextEditingController(text: widget.categoryId ?? '');
    _qntyController = TextEditingController(text: widget.quantity ?? '');
    _weightInGramController = TextEditingController(text: widget.weightInGram ?? '');
    _costPerGramController = TextEditingController(text: widget.costPerGram ?? '');
    _sellPriceController = TextEditingController(text: widget.sellPrice ?? '');
    _isActive = (widget.active ?? 1) == 1;
    _forSale = (widget.forSale ?? 1) == 1;
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

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _newImage = File(picked.path));
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    http.MultipartFile? imageFile;
    if (_newImage != null) {
      imageFile = await http.MultipartFile.fromPath('image', _newImage!.path);
    }
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
    context.read<ProductBloc>().add(UpdateProduct(widget.productId, fields, imageFile: imageFile));
    // Navigation is handled by BlocListener.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Update Product',
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
        headerSubtitle: 'Update Product',
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (!state.isLoading && state.updatedProduct != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product updated successfully'), backgroundColor: Colors.black87),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _newImage != null
                          ? Image.file(_newImage!, fit: BoxFit.cover)
                          : (widget.image != null && widget.image!.isNotEmpty
                              ? Image.network(widget.image!, fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.image, size: 60, color: Colors.black26))
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 48, color: Colors.black38),
                                    SizedBox(height: 8),
                                    Text('Tap to select image', style: TextStyle(color: Colors.black45)),
                                  ],
                                )),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Tap image to change (optional)', style: TextStyle(color: Colors.black38, fontSize: 12)),
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
                    onPressed: _updateProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Update', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
