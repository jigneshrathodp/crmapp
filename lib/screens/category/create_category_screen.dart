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

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  File? _selectedImage;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
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
          const SnackBar(
            content: Text('Please select a category image'),
            backgroundColor: Colors.black87,
          ),
        );
        return;
      }
      final imageFile = await http.MultipartFile.fromPath('image', _selectedImage!.path);
      if (!mounted) return;
      context.read<CategoryBloc>().add(
        CreateCategory(
          {'name': _nameController.text, 'skubar_code': _skuController.text},
          imageFile: imageFile,
        ),
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
        title: 'Create Category',
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
        headerSubtitle: 'Create Category',
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdCategory != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Category created successfully'),
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
                const SizedBox(height: 16),
                // Image picker
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
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 48, color: Colors.black38),
                              SizedBox(height: 8),
                              Text(
                                'Tap to select image (required)',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                          : const Text('Create', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
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
