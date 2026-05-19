import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/advertise_bloc.dart';
import '../../events/advertise_events.dart';
import '../../states/advertise_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/navigation_mixin.dart';

class CreateAdsScreen extends StatefulWidget {
  const CreateAdsScreen({super.key});

  @override
  State<CreateAdsScreen> createState() => _CreateAdsScreenState();
}

class _CreateAdsScreenState extends State<CreateAdsScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedSocialMedia = 'facebook';

  final List<String> _socialMediaOptions = [
    'facebook',
    'instagram',
    'twitter',
    'threads',
    'pinterest',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _urlController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.black87,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AdvertiseBloc>().add(
        CreateAdvertise({
          'date': _dateController.text,
          'title': _titleController.text,
          'price': _priceController.text,
          'url': _urlController.text,
          'socialmedia': _selectedSocialMedia,
        }),
      );
      // Let BlocListener handle the success SnackBar before popping.
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

  InputDecoration _dec(String label, {Widget? suffix}) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _focusBorder,
        suffixIcon: suffix,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Create Advertisement',
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
        selectedIndex: 7,
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Create Advertisement',
      ),
      body: BlocListener<AdvertiseBloc, AdvertiseState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdAdvertise != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Advertisement created successfully'),
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
                  controller: _titleController,
                  decoration: _dec('Title'),
                  validator: (v) => v?.isEmpty ?? true ? 'Title is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateController,
                  decoration: _dec(
                    'Date (YYYY-MM-DD)',
                    suffix: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
                  ),
                  readOnly: true,
                  onTap: _pickDate,
                  validator: (v) => v?.isEmpty ?? true ? 'Date is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: _dec('Price'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Price is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _urlController,
                  decoration: _dec('URL'),
                  keyboardType: TextInputType.url,
                  validator: (v) => v?.isEmpty ?? true ? 'URL is required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSocialMedia,
                  decoration: _dec('Social Media'),
                  items: _socialMediaOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedSocialMedia = value);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
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
