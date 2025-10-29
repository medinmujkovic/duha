import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/notifications/data/models/notification_enum.dart';
import 'package:duha_app/features/notifications/data/models/notifications_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedTab extends ConsumerStatefulWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends ConsumerState<FeedTab>
    with AutomaticKeepAliveClientMixin {
  final DataService _dataService = DataService();
  List<Notifications> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Schedule the load after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeed();
    });
  }

  Future<void> _loadFeed() async {
    final userId = ref.read(userProvider)?.id;

    if (userId == null) {
      setState(() {
        _error = 'User not authenticated';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      // final activities = await _dataService.getFeedForUser(userId);

      // Mock data for now
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API call
      final activities = _dataService.getActivitiesForUser(userId);

      setState(() {
        _activities = activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userId = ref.read(userProvider)?.id;
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(_error!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFeed,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFeed,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];

          Widget leading;
          Widget title;
          Widget? subtitle;
          Widget? trailing;

          switch (activity.type) {
            case NotificationType.groupInvite:
              leading = const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.group_add, color: Colors.white),
              );
              title = Text(
                '${activity.name} invited you to ${activity.content}!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
              subtitle = Text('Tap to view or accept the invitation');
              trailing = ElevatedButton(
                onPressed: () {
                  _dataService.addGroupMembers(activity.groupId!,[userId!]);
                  _dataService.deleteNotification(activity.id);
                  _loadFeed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 105, 206, 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Join'),
              );
              break;
            case NotificationType.friendsUpdate:
              leading = CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white),
              );
              title = Text(
                '${activity.name} just updated their progress!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
              trailing = IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // TODO: like/follow
                },
              );
              break;

            default:
              leading = const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.notifications, color: Colors.white),
              );
              title = Text(activity.name ?? 'Unknown');
              subtitle = Text('New activity');
              trailing = null;
          }

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: leading,
              title: title,
              subtitle: subtitle,
              trailing: trailing,
              onTap: () {
                // Optional: open details page depending on type
              },
            ),
          );
        },
      ),
    );
  }
}
