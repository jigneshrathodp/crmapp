import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../events/profile_events.dart';
import '../../states/profile_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../../utils/navigation_mixin.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Profile',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        ),
        showProfile: false,
      ),
      drawer: CustomDrawer(
        selectedIndex: 10,
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Profile',
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black87));
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 56, color: Colors.black38),
                  const SizedBox(height: 12),
                  Text('Error: ${state.error}', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileBloc>().add(GetProfileDetails()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87, foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.profileDetails == null) {
            return const Center(child: CircularProgressIndicator(color: Colors.black87));
          }

          final profile = state.profileDetails!;
          // API: { status, user: { id, name, email, contact, image }, details: {...} }
          final user = profile['user'] is Map
              ? Map<String, dynamic>.from(profile['user'] as Map)
              : profile;
          final details = profile['details'] is Map
              ? Map<String, dynamic>.from(profile['details'] as Map)
              : {};
              
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile header card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: user['image'] != null && user['image'].toString().isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                user['image'].toString(),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded, color: Colors.white, size: 30),
                              ),
                            )
                          : const Icon(Icons.person_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name']?.toString() ?? 'N/A',
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user['email']?.toString() ?? 'N/A',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _infoCard(Icons.phone_rounded, 'Contact', user['contact']?.toString() ?? 'N/A'),
              
              if (details.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('Company Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                _infoCard(Icons.business_rounded, 'Site Name', details['site_name']?.toString() ?? 'N/A'),
                const SizedBox(height: 12),
                _infoCard(Icons.location_on_rounded, 'Address', details['address']?.toString() ?? 'N/A'),
                const SizedBox(height: 12),
                _infoCard(Icons.info_outline_rounded, 'Footer', details['footer']?.toString() ?? 'N/A'),
                
                if (details['fav_icon'] != null || details['logo_light'] != null || details['logo_dark'] != null) ...[
                  const SizedBox(height: 24),
                  const Text('Brand Assets', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (details['fav_icon'] != null && details['fav_icon'].toString().isNotEmpty)
                        _imageBox('Favicon', details['fav_icon'].toString()),
                      if (details['logo_light'] != null && details['logo_light'].toString().isNotEmpty)
                        _imageBox('Logo Light', details['logo_light'].toString()),
                      if (details['logo_dark'] != null && details['logo_dark'].toString().isNotEmpty)
                        _imageBox('Logo Dark', details['logo_dark'].toString()),
                    ],
                  ),
                ],
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    ).then((_) {
                      if (context.mounted) {
                        context.read<ProfileBloc>().add(GetProfileDetails());
                      }
                    });
                  },
                  label: const Text('Update Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 48,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.lock, color: Colors.black87),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                  label: const Text('Reset Password',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageBox(String label, String url) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Image.network(
            url,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.black26, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
