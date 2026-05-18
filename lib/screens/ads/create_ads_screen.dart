import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/advertise_bloc.dart';
import '../../events/advertise_events.dart';
import '../../states/advertise_state.dart';

class CreateAdsScreen extends StatefulWidget {
  const CreateAdsScreen({super.key});

  @override
  State<CreateAdsScreen> createState() => _CreateAdsScreenState();
}

class _CreateAdsScreenState extends State<CreateAdsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlController = TextEditingController();
  final _dateController = TextEditingController();
  // API requires: date, price, title, url, socialmedia
  // socialmedia must be one of: facebook, instagram, twitter, threads, pinterest
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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Advertisement'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocListener<AdvertiseBloc, AdvertiseState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdAdvertise != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Advertisement created successfully')),
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
                ElevatedButton(onPressed: _submit, child: const Text('Create')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
