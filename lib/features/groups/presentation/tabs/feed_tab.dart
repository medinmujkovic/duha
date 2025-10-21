  import 'package:duha_app/features/auth/data/models/user_provider.dart';
import 'package:duha_app/features/projects/data/models/user_activity_model/user_activity_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab>
    with AutomaticKeepAliveClientMixin {

  final DataService _dataService = DataService();
  List<UserActivity> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    final userProvider = Provider<UserProvider>(context, listen: false);
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
      // TODO: Replace with actual API call
      // final activities = await _dataService.getFeedForUser(userId);
      
      // Mock data for now
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API call
      final activities = _dataService.getRecentActivities();

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
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFF7C3AED),
                child: Text(
                  activity.username,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: '${activity.username} ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              subtitle: Row(
                children: [
                  Text(activity.streak),
                   ...[
                    SizedBox(width: 12),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      ' +${activity.xp} XP',
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  // TODO: Implement like functionality
                },
              ),
            ),
          );
        },
      ),
    );
  }
}