import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/advertise_bloc.dart';
import '../events/advertise_events.dart';
import '../states/advertise_state.dart';
import '../widgets/advertise_widgets.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'advertise_update_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

// Convert to StatefulWidget to dispatch GetAdvertiseList in initState
class AdvertiseScreen extends StatefulWidget {
  const AdvertiseScreen({super.key});

  @override
  State<AdvertiseScreen> createState() => _AdvertiseScreenState();
}

class _AdvertiseScreenState extends State<AdvertiseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<AdvertiseBloc>().add(GetAdvertiseList());
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pushReplacementNamed(context, _indexToRoute(index));
  }

  String _indexToRoute(int index) {
    switch (index) {
      case 0:
        return '/dashboard';
      case 1:
      case 2:
        return '/orders';
      case 3:
      case 4:
        return '/products';
      case 5:
      case 6:
        return '/categories';
      case 7:
      case 8:
        return '/advertisements';
      case 9:
        return '/notifications';
      case 10:
      case 11:
      case 12:
        return '/profile';
      default:
        return '/dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Advertisements',
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
        onItemTapped: _onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Advertisements',
      ),
      body: BlocBuilder<AdvertiseBloc, AdvertiseState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AdvertiseBloc>().add(GetAdvertiseList()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.advertiseList?.data == null ||
              state.advertiseList!.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No advertisements found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AdvertiseBloc>().add(GetAdvertiseList()),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return AdvertiseListWidget(
            advertises: state.advertiseList!.data!,
            onRefresh: () =>
                context.read<AdvertiseBloc>().add(GetAdvertiseList()),
            onDelete: (id) =>
                context.read<AdvertiseBloc>().add(DeleteAdvertise(id)),
            // Navigate to AdvertiseUpdateScreen on tap, reload list on return
            onTap: (advertise) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdvertiseUpdateScreen(
                    advertiseId: advertise.id!,
                    advertiseTitle: advertise.title,
                    advertiseDate: advertise.date,
                    advertisePrice: advertise.price,
                    advertiseUrl: advertise.url,
                    advertiseSocialMedia: advertise.socialmedia,
                  ),
                ),
              ).then(
                  (_) => context.read<AdvertiseBloc>().add(GetAdvertiseList()));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAdvertiseScreen(),
            ),
          ).then((_) => context.read<AdvertiseBloc>().add(GetAdvertiseList()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateAdvertiseScreen extends StatefulWidget {
  const CreateAdvertiseScreen({super.key});

  @override
  State<CreateAdvertiseScreen> createState() => _CreateAdvertiseScreenState();
}

class _CreateAdvertiseScreenState extends State<CreateAdvertiseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlController = TextEditingController();
  final _dateController = TextEditingController();
  // Fixed: API requires: date, price, title, url, socialmedia
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
      body: Padding(
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
    );
  }
}
