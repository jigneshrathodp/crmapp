import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../events/notification_events.dart';
import '../states/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load unread notifications on open
    context.read<NotificationBloc>().add(GetUnreadNotifications());

    // Dispatch correct event when switching tabs
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      if (_tabController.index == 0) {
        context.read<NotificationBloc>().add(GetUnreadNotifications());
      } else {
        context.read<NotificationBloc>().add(GetReadNotifications());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Unread'),
            Tab(text: 'Read'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllNotificationsRead());
              // Reload unread list after marking all read
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  context.read<NotificationBloc>().add(GetUnreadNotifications());
                }
              });
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
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
                    onPressed: () => context.read<NotificationBloc>().add(
                          GetUnreadNotifications(),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildNotificationList(
                state.unreadNotifications ?? [],
                isUnread: true,
              ),
              _buildNotificationList(
                state.readNotifications ?? [],
                isUnread: false,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationList(
    List<dynamic> notifications, {
    required bool isUnread,
  }) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          isUnread ? 'No unread notifications' : 'No read notifications',
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            // Fixed: API returns 'type' and nested 'order'/'advertise', not 'title'/'message'
            title: Text(notification['type']?.toString() ?? 'Notification'),
            subtitle: Text(
              notification['order'] != null
                  ? 'Customer: ${notification['order']['customer_name'] ?? ''}'
                  : notification['advertise'] != null
                      ? 'Advertise: ${notification['advertise'].toString()}'
                      : 'No details',
            ),
            trailing: isUnread
                ? IconButton(
                    icon: const Icon(Icons.mark_email_read),
                    onPressed: () {
                      context.read<NotificationBloc>().add(
                            MarkNotificationRead(notification['id'] as int),
                          );
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<NotificationBloc>().add(
                            DeleteNotification(notification['id'] as int),
                          );
                    },
                  ),
          ),
        );
      },
    );
  }
}
