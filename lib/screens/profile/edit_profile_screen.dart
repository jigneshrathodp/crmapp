import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../bloc/profile_bloc.dart';
import '../../events/profile_events.dart';
import '../../states/profile_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import 'profile_screen.dart';
import '../../utils/navigation_mixin.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  String? _existingProfileImage;
  String? _existingFavIcon;
  String? _existingLogoDark;
  String? _existingLogoLight;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    final profile = state.profileDetails;
    if (profile != null) {
      final user = profile['user'] is Map ? profile['user'] as Map : profile;
      final details = profile['details'] is Map ? profile['details'] as Map : {};
      
      _nameController.text = user['name']?.toString() ?? '';
      _emailController.text = user['email']?.toString() ?? '';
      _phoneController.text = user['contact']?.toString() ?? '';
      
      _siteNameController.text = details['site_name']?.toString() ?? '';
      _footerController.text = details['footer']?.toString() ?? '';
      _addressController.text = details['address']?.toString() ?? '';

      _existingProfileImage = user['image']?.toString();
      _existingFavIcon = details['fav_icon']?.toString();
      _existingLogoDark = details['logo_dark']?.toString();
      _existingLogoLight = details['logo_light']?.toString();
    }
  }

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
      // BlocListener will handle success snackbar and navigation.
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

  Widget _imageTile({
    required String label,
    required String field,
    required File? file,
    String? networkUrl,
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
                    : (networkUrl != null && networkUrl.isNotEmpty)
                        ? Image.network(networkUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildPlaceholder())
                        : _buildPlaceholder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  file != null 
                      ? '$label selected ✓' 
                      : (networkUrl != null && networkUrl.isNotEmpty)
                          ? 'Tap to change $label'
                          : 'Tap to select $label (optional)',
                  style: TextStyle(
                    color: file != null ? Colors.black87 : Colors.black54,
                    fontWeight: file != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade200,
      child: const Icon(Icons.add_photo_alternate, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Edit Profile',
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
        selectedIndex: 8,
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Edit Profile',
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.profileDetails != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
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
                const Text('Personal Details',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: _dec('Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: _dec('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Email is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: _dec('Contact / Phone'),
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
                  decoration: _dec('Site Name (optional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _footerController,
                  decoration: _dec('Footer Text (optional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: _dec('Address (optional)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                const Text('Images',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                _imageTile(
                    label: 'Profile Image', field: 'image', file: _profileImage, networkUrl: _existingProfileImage),
                _imageTile(
                    label: 'Favicon', field: 'fav_icon', file: _favIconImage, networkUrl: _existingFavIcon),
                _imageTile(
                    label: 'Logo (Dark)', field: 'logo_dark', file: _logoDarkImage, networkUrl: _existingLogoDark),
                _imageTile(
                    label: 'Logo (Light)', field: 'logo_light', file: _logoLightImage, networkUrl: _existingLogoLight),
                const SizedBox(height: 16),
                BlocBuilder<ProfileBloc, ProfileState>(
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
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Update', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
