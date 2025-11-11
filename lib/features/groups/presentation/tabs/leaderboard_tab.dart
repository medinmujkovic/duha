import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/common/providers/data_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardTab extends ConsumerWidget {
  const LeaderboardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataService = ref.watch(dataServiceProvider);
    final me = ref.watch(userProvider);
    final userId = me?.id;
    if (userId == null) {
      return const Center(child: Text('User not authenticated'));
    }

    final friendsStream = dataService.getUserFriendsStream(userId);

    return StreamBuilder<List<UserModel>>(
      stream: friendsStream,
      builder: (context, snapshot) {
        final friends = snapshot.data ?? <UserModel>[];

        final allUsers = <UserModel>[me!, ...friends]
          ..sort((a, b) {
            final byXp = b.xp.compareTo(a.xp);
            if (byXp != 0) return byXp;
            final byName = (a.name ?? '').compareTo(b.name ?? '');
            if (byName != 0) return byName;
            return (a.id ?? '').compareTo(b.id ?? '');
          });

        final myIndex = allUsers.indexWhere((u) => u.id == userId);
        final myRank = myIndex + 1;

        Color? medalColorFor(int rank) {
          if (rank == 1) return Colors.amber;
          if (rank == 2) return Colors.grey[400];
          if (rank == 3) return Colors.orange[300];
          return null;
        }

        final leaderboardRows = allUsers.where((u) => u.id != userId).toList();

        return RefreshIndicator(
          onRefresh: () async {
            // invalidate the provider to trigger a reload
            ref.invalidate(dataServiceProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 1 + (leaderboardRows.isEmpty ? 0 : leaderboardRows.length),
            itemBuilder: (context, index) {
          if (index == 0) {
            // HEADER: Your progress card
            final color = medalColorFor(myRank) ?? const Color(0xFF7C3AED);
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 1.5,
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      myRank.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  me.name ?? 'You',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(' ${me.xp} XP'),
                    const SizedBox(width: 12),
                    const Icon(Icons.local_fire_department,
                        size: 14, color: Colors.orange),
                    Text(' ${me.streak}d'),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, color: Color(0xFF7C3AED)),
                    Text(
                      'Lvl ${me.level}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }

          // Leaderboard rows (including you, highlighted)
          final u = leaderboardRows[index - 1];
          final rank =
              allUsers.indexWhere((x) => x.id == u.id) + 1; // keeps true rank
          final medalColor = medalColorFor(rank);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: medalColor ?? Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: rank <= 3 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              title: Text(u.name ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(' ${u.xp} XP'),
                  const SizedBox(width: 12),
                  const Icon(Icons.local_fire_department,
                      size: 14, color: Colors.orange),
                  Text(' ${u.streak}d'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, color: Color(0xFF7C3AED)),
                  Text(
                    'Lvl ${u.level}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
      },
    );
  }
}
