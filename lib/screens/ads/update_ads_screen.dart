import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/advertise_bloc.dart';
import '../../events/advertise_events.dart';
import '../../states/advertise_state.dart';

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

class _UpdateAdsScreenState extends State<UpdateAdsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;
  late TextEditingController _urlController;
  late String _selectedSocialMedia;

  final List<String> _socialMediaOptions = [
    'facebook',
    'instagram',
    'twitter',
    'threads',
    'pinterest',
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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Advertisement'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocListener<AdvertiseBloc, AdvertiseState>(
        listener: (context, state) {
          if (state.updatedAdvertise != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Advertisement updated successfully'),
              ),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Title is required' : null,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: 'YYYY-MM-DD',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _pickDate,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Date is required' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Price is required' : null,
                ),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(labelText: 'URL'),
                  keyboardType: TextInputType.url,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'URL is required' : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSocialMedia,
                  decoration: const InputDecoration(labelText: 'Social Media'),
                  items: _socialMediaOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedSocialMedia = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateAdvertise,
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
