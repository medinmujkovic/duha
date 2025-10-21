import 'package:duha_app/features/auth/data/models/user_provider.dart';
import 'package:duha_app/features/projects/data/models/user_activity_model/user_activity_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({Key? key}) : super(key: key);

  @override
  _LeaderboardTabState createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab>
    with AutomaticKeepAliveClientMixin {
  final DataService _dataService = DataService();
  List<UserActivity> _leaderboard = [];
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

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
      // Replace this with your actual API call
      // final groups = await _dataService.getGroupsForUser(userId);

      // For now, using local data service
      final leaderboard = _dataService.getLeaderboard(userId);

      setState(() {
        _leaderboard = leaderboard;
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
              onPressed: _loadLeaderboard,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLeaderboard,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _leaderboard.length,
        itemBuilder: (context, index) {
          final user = _leaderboard[index];
          final rank = index + 1;
          Color? medalColor;

          if (rank == 1) medalColor = Colors.amber;
          if (rank == 2) medalColor = Colors.grey[400];
          if (rank == 3) medalColor = Colors.orange[300];

          return Card(
            margin: EdgeInsets.only(bottom: 12),
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
                user.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(' ${user.xp} XP'),
                  SizedBox(width: 12),
                  Icon(Icons.local_fire_department,
                      size: 14, color: Colors.orange),
                  Text(' ${user.streak}d'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Color(0xFF7C3AED)),
                  Text(
                    'Lvl ${user.level}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
