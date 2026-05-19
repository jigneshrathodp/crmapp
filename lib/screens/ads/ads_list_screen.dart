import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/advertise_bloc.dart';
import '../../events/advertise_events.dart';
import '../../states/advertise_state.dart';
import '../../widgets/advertise_widgets.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/navigation_mixin.dart';
import 'create_ads_screen.dart';
import 'update_ads_screen.dart';

class AdsListScreen extends StatefulWidget {
  const AdsListScreen({super.key});

  @override
  State<AdsListScreen> createState() => _AdsListScreenState();
}

class _AdsListScreenState extends State<AdsListScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<AdvertiseBloc>().add(GetAdvertiseList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Advertisements',
      ),
      body: BlocBuilder<AdvertiseBloc, AdvertiseState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black87),
            );
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 56, color: Colors.black38),
                  const SizedBox(height: 12),
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AdvertiseBloc>().add(GetAdvertiseList()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                    ),
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
                  const Icon(Icons.campaign_outlined, size: 64, color: Colors.black26),
                  const SizedBox(height: 12),
                  const Text(
                    'No Data Available',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AdvertiseBloc>().add(GetAdvertiseList()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                    ),
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
            onTap: (advertise) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateAdsScreen(
                    advertiseId: advertise.id!,
                    advertiseTitle: advertise.title,
                    advertiseDate: advertise.date,
                    advertisePrice: advertise.price,
                    advertiseUrl: advertise.url,
                    advertiseSocialMedia: advertise.socialmedia,
                  ),
                ),
              ).then((_) {
                if (context.mounted) {
                  context.read<AdvertiseBloc>().add(GetAdvertiseList());
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateAdsScreen()),
          ).then((_) {
            if (context.mounted) {
              context.read<AdvertiseBloc>().add(GetAdvertiseList());
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
