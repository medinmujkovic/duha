import 'package:duha_app/common/providers/data_service_provider.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/notifications/data/models/notification_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedTab extends ConsumerWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataService = ref.watch(dataServiceProvider);
    final user = ref.watch(userProvider);
    final userId = user?.id;

    if (userId == null) {
      return const Center(child: Text('User not authenticated'));
    }
    final notificationsAsync = ref.watch(userNotificationsStreamProvider(userId));

    return RefreshIndicator(
      onRefresh: () async {
        // Trigger a re-evaluation of the notifications provider
        final _ = ref.refresh(userNotificationsStreamProvider(userId));
        // brief pause to allow UI/provider to update
        await Future.delayed(const Duration(milliseconds: 200));
      },
      child: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (notifications) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final activity = notifications[index];

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
                    onPressed: () async {
                      if (activity.groupId != null) {
                        await dataService
                            .addGroupMembers(activity.groupId!, [userId]);
                      }
                      await dataService.deleteNotification(activity.id);
                      // refresh the notifications provider so UI updates
                      final __ =
                          ref.refresh(userNotificationsStreamProvider(userId));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 105, 206, 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
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
            ); // end ListView.builder
        }, // end data
      ), // end when
    ); // end RefreshIndicator
  }
}
