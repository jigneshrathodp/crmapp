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
              ).then(
                (_) => context.read<AdvertiseBloc>().add(GetAdvertiseList()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateAdsScreen()),
          ).then((_) => context.read<AdvertiseBloc>().add(GetAdvertiseList()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
