import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../bloc/category_bloc.dart';
import '../../events/category_events.dart';
import '../../states/category_state.dart';

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

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
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
          {
            'name': _nameController.text,
            'skubar_code': _skuController.text,
          },
          imageFile: imageFile,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Category'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.updatedCategory != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Category updated successfully')),
            );
            Navigator.pop(context);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
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
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _newImage != null
                        ? Image.file(_newImage!, fit: BoxFit.cover)
                        : (widget.categoryImage != null
                            ? Image.network(
                                widget.categoryImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.category, size: 80),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 48, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Tap to change image',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              )),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap image to select a new one (optional)',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _skuController,
                      decoration: const InputDecoration(
                        labelText: 'SKU Barcode',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'SKU is required' : null,
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: state.isLoading ? null : _updateCategory,
                            icon: state.isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child:
                                        CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.save),
                            label: const Text('Update'),
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
