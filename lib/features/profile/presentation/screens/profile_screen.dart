import 'package:duha_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    final user = _dataService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Profile Header
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF7C3AED),
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Level', user.level.toString(), Icons.emoji_events),
                      _buildStatColumn('XP', user.xp.toString(), Icons.star),
                      _buildStatColumn('Streak', '${user.streak}d', Icons.local_fire_department),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Achievements
          Text(
            'Achievements',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildBadge('Early Bird', Icons.wb_sunny, Colors.orange, true),
              _buildBadge('Team Player', Icons.people, Colors.blue, true),
              _buildBadge('Speedster', Icons.speed, Colors.purple, true),
              _buildBadge('Consistent', Icons.check_circle, Colors.green, true),
              _buildBadge('Achiever', Icons.emoji_events, Colors.amber, true),
              _buildBadge('Master', Icons.workspace_premium, Colors.grey, false),
            ],
          ),
          SizedBox(height: 20),

          // Settings Options
          Text(
            'Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text('Dark Mode'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Help & Support'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Color(0xFF7C3AED)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color, bool unlocked) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked ? color.withOpacity(0.1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? color.withOpacity(0.3) : Colors.grey[300]!,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: unlocked ? color : Colors.grey[400],
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: unlocked ? Colors.black : Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}