import 'package:duha_app/features/groups/presentation/screens/group_detail_screen.dart';
import 'package:duha_app/features/projects/data/models/project_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Leaderboard'),
            Tab(text: 'Groups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedTab(),
          _buildLeaderboardTab(),
          _buildGroupsTab(),
        ],
      ),
    );
  }

  Widget _buildFeedTab() {
    final activities = [
      {
        'user': 'Sarah',
        'action': 'completed',
        'task': 'Weekly Report',
        'xp': 60,
        'time': '2 min ago'
      },
      {
        'user': 'You',
        'action': 'achieved',
        'milestone': '7-day streak',
        'xp': 100,
        'time': '1 hour ago'
      },
      {
        'user': 'Ahmed',
        'action': 'leveled up',
        'level': 15,
        'time': '2 hours ago'
      },
      {
        'user': 'Alex',
        'action': 'completed',
        'task': 'Code Review',
        'xp': 80,
        'time': '3 hours ago'
      },
      {
        'user': 'Team Dev',
        'action': 'completed',
        'task': 'Sprint Planning',
        'xp': 120,
        'time': '5 hours ago'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF7C3AED),
              child: Text(
                activity['user'].toString()[0],
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(
                    text: '${activity['user']} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '${activity['action']} '),
                  if (activity.containsKey('task'))
                    TextSpan(
                      text: activity['task'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  if (activity.containsKey('milestone'))
                    TextSpan(
                      text: activity['milestone'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  if (activity.containsKey('level'))
                    TextSpan(
                      text: 'to level ${activity['level']}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
            subtitle: Row(
              children: [
                Text(activity['time'].toString()),
                if (activity.containsKey('xp')) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(
                    ' +${activity['xp']} XP',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardTab() {
    final leaderboard = [
      {'name': 'Sarah', 'xp': 3200, 'level': 15, 'streak': 12},
      {'name': 'You', 'xp': 2450, 'level': 12, 'streak': 7},
      {'name': 'Ahmed', 'xp': 2100, 'level': 11, 'streak': 5},
      {'name': 'Alex', 'xp': 1800, 'level': 10, 'streak': 3},
      {'name': 'Mike', 'xp': 1500, 'level': 9, 'streak': 2},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final user = leaderboard[index];
        final rank = index + 1;
        Color? medalColor;

        if (rank == 1) medalColor = Colors.amber;
        if (rank == 2) medalColor = Colors.grey[400];
        if (rank == 3) medalColor = Colors.orange[300];

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
            title: Text(
              user['name'].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(' ${user['xp']} XP'),
                const SizedBox(width: 12),
                const Icon(Icons.local_fire_department,
                    size: 14, color: Colors.orange),
                Text(' ${user['streak']}d'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Color(0xFF7C3AED)),
                Text(
                  'Lvl ${user['level']}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsTab() {
    final groups = _dataService.getGroups();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share Your Group',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Invite team members to collaborate on your groups',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showCreateGroupDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Your Groups',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...groups.map((group) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // router will be implemented later
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupDetailScreen(groupId: group.id),
                  ),
                );
              },
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getColorFromString(group.color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.folder, color: Colors.white),
                ),
                title: Text(
                  group.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.people, size: 14),
                    const SizedBox(width: 4),
                    Text('${group.memberIds.length} members'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _showShareDialog(context, group),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _getColorFromString(String color) {
    switch (color) {
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedColor = 'purple';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Color'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  ['purple', 'blue', 'green', 'orange', 'pink'].map((color) {
                return GestureDetector(
                  onTap: () => selectedColor = color,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getColorFromString(color),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _dataService.addGroup(nameController.text, selectedColor);
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, GroupModel group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this link with your team:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                group.shareLink,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
