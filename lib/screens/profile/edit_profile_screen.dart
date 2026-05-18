import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../bloc/profile_bloc.dart';
import '../../events/profile_events.dart';
import '../../states/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // User fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Business/branding fields
  final _siteNameController = TextEditingController();
  final _footerController = TextEditingController();
  final _addressController = TextEditingController();

  // Image files
  File? _profileImage;
  File? _favIconImage;
  File? _logoDarkImage;
  File? _logoLightImage;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _siteNameController.dispose();
    _footerController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String field) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        switch (field) {
          case 'image':
            _profileImage = File(picked.path);
            break;
          case 'fav_icon':
            _favIconImage = File(picked.path);
            break;
          case 'logo_dark':
            _logoDarkImage = File(picked.path);
            break;
          case 'logo_light':
            _logoLightImage = File(picked.path);
            break;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Collect text fields (only non-empty)
      final fields = <String, String>{};
      if (_nameController.text.isNotEmpty) fields['name'] = _nameController.text;
      if (_emailController.text.isNotEmpty) fields['email'] = _emailController.text;
      if (_phoneController.text.isNotEmpty) fields['contact'] = _phoneController.text;
      if (_siteNameController.text.isNotEmpty) fields['site_name'] = _siteNameController.text;
      if (_footerController.text.isNotEmpty) fields['footer'] = _footerController.text;
      if (_addressController.text.isNotEmpty) fields['address'] = _addressController.text;

      // Collect image files
      final imageFiles = <String, http.MultipartFile>{};
      if (_profileImage != null) {
        imageFiles['image'] =
            await http.MultipartFile.fromPath('image', _profileImage!.path);
      }
      if (_favIconImage != null) {
        imageFiles['fav_icon'] =
            await http.MultipartFile.fromPath('fav_icon', _favIconImage!.path);
      }
      if (_logoDarkImage != null) {
        imageFiles['logo_dark'] =
            await http.MultipartFile.fromPath('logo_dark', _logoDarkImage!.path);
      }
      if (_logoLightImage != null) {
        imageFiles['logo_light'] =
            await http.MultipartFile.fromPath('logo_light', _logoLightImage!.path);
      }

      if (!mounted) return;
      context.read<ProfileBloc>().add(
        UpdateProfile(fields, imageFiles: imageFiles.isEmpty ? null : imageFiles),
      );
      Navigator.pop(context);
    }
  }

  Widget _imageTile({
    required String label,
    required String field,
    required File? file,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _pickImage(field),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(8)),
                child: file != null
                    ? Image.file(file,
                        width: 80, height: 80, fit: BoxFit.cover)
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.add_photo_alternate,
                            color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  file != null ? '$label selected ✓' : 'Tap to select $label (optional)',
                  style: TextStyle(
                    color: file != null ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.profileDetails != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
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
                const Text('Personal Details',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Email is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Contact / Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Contact is required' : null,
                ),
                const SizedBox(height: 20),
                const Text('Branding / Site Details',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _siteNameController,
                  decoration: const InputDecoration(
                    labelText: 'Site Name (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _footerController,
                  decoration: const InputDecoration(
                    labelText: 'Footer Text (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                const Text('Images',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                _imageTile(
                    label: 'Profile Image', field: 'image', file: _profileImage),
                _imageTile(
                    label: 'Favicon', field: 'fav_icon', file: _favIconImage),
                _imageTile(
                    label: 'Logo (Dark)', field: 'logo_dark', file: _logoDarkImage),
                _imageTile(
                    label: 'Logo (Light)', field: 'logo_light', file: _logoLightImage),
                const SizedBox(height: 16),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Update'),
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
