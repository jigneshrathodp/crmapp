import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../bloc/category_bloc.dart';
import '../../events/category_events.dart';
import '../../states/category_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/navigation_mixin.dart';

class UpdateCategoryScreen extends StatefulWidget {
  final int categoryId;
  final String? categoryName;
  final String? categorySku;
  final String? categoryImage;

  const UpdateCategoryScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
    this.categorySku,
    this.categoryImage,
  });

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  File? _newImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.categoryName ?? '');
    _skuController = TextEditingController(text: widget.categorySku ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _newImage = File(picked.path));
    }
  }

  Future<void> _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      http.MultipartFile? imageFile;
      if (_newImage != null) {
        imageFile = await http.MultipartFile.fromPath('image', _newImage!.path);
      }
      if (!mounted) return;
      context.read<CategoryBloc>().add(
        UpdateCategory(
          widget.categoryId,
          {'name': _nameController.text, 'skubar_code': _skuController.text},
          imageFile: imageFile,
        ),
      );
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
        title: 'Update Category',
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
        selectedIndex: 5,
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Update Category',
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.updatedCategory != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Category updated successfully'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image preview / picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade50,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _newImage != null
                        ? Image.file(_newImage!, fit: BoxFit.cover)
                        : (widget.categoryImage != null
                            ? Image.network(
                                widget.categoryImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.category, size: 80, color: Colors.black26),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 48, color: Colors.black38),
                                  SizedBox(height: 8),
                                  Text('Tap to change image',
                                      style: TextStyle(color: Colors.black45)),
                                ],
                              )),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tap image to select a new one (optional)',
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _dec('Name'),
                      validator: (v) => v?.isEmpty ?? true ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _skuController,
                      decoration: _dec('SKU Barcode'),
                      validator: (v) => v?.isEmpty ?? true ? 'SKU is required' : null,
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: state.isLoading ? null : _updateCategory,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Update',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
