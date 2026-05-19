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

class UpdateAdsScreen extends StatefulWidget {
  final int advertiseId;
  final String? advertiseTitle;
  final String? advertiseDate;
  final String? advertisePrice;
  final String? advertiseUrl;
  final String? advertiseSocialMedia;

  const UpdateAdsScreen({
    super.key,
    required this.advertiseId,
    this.advertiseTitle,
    this.advertiseDate,
    this.advertisePrice,
    this.advertiseUrl,
    this.advertiseSocialMedia,
  });

  @override
  State<UpdateAdsScreen> createState() => _UpdateAdsScreenState();
}

class _UpdateAdsScreenState extends State<UpdateAdsScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;
  late TextEditingController _urlController;
  late String _selectedSocialMedia;

  final List<String> _socialMediaOptions = [
    'facebook', 'instagram', 'twitter', 'threads', 'pinterest',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.advertiseTitle ?? '');
    _dateController = TextEditingController(text: widget.advertiseDate ?? '');
    _priceController = TextEditingController(text: widget.advertisePrice ?? '');
    _urlController = TextEditingController(text: widget.advertiseUrl ?? '');
    _selectedSocialMedia =
        (widget.advertiseSocialMedia != null &&
            _socialMediaOptions.contains(widget.advertiseSocialMedia))
        ? widget.advertiseSocialMedia!
        : 'facebook';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
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

  void _updateAdvertise() {
    if (_formKey.currentState!.validate()) {
      context.read<AdvertiseBloc>().add(
        UpdateAdvertise(widget.advertiseId, {
          'title': _titleController.text,
          'date': _dateController.text,
          'price': _priceController.text,
          'url': _urlController.text,
          'socialmedia': _selectedSocialMedia,
        }),
      );
      // Navigation is handled by BlocListener.
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
        title: 'Update Advertisement',
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
        headerSubtitle: 'Update Advertisement',
      ),
      body: BlocListener<AdvertiseBloc, AdvertiseState>(
        listener: (context, state) {
          if (!state.isLoading && state.updatedAdvertise != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Advertisement updated successfully'),
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
                    onPressed: _updateAdvertise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
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
