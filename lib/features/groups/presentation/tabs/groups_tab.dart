import 'package:duha_app/features/auth/data/models/user_provider.dart';
import 'package:duha_app/features/groups/presentation/screens/group_detail_screen.dart';
import 'package:duha_app/features/projects/data/models/project_model/project_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsTab extends StatefulWidget {
  const GroupsTab({Key? key}) : super(key: key);

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab>
    with AutomaticKeepAliveClientMixin {
  final DataService _dataService = DataService();
  List<GroupModel> _groups = [];
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true; // Keep state when switching tabs

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
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
      final groups = _dataService.getGroups(userId);
      
      setState(() {
        _groups = groups;
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin

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
              onPressed: _loadGroups,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGroups,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share Your Group',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Invite team members to collaborate on your groups',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateGroupDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Create New Group'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Your Groups',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          if (_groups.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No groups yet. Create one to get started!',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ..._groups.map((group) {
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupDetailScreen(groupId: group.id),
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
                      child: Icon(Icons.folder, color: Colors.white),
                    ),
                    title: Text(
                      group.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.people, size: 14),
                        SizedBox(width: 4),
                        Text('${group.memberIds.length} members'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () => _showShareDialog(context, group),
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
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
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Create New Group'),
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
              SizedBox(height: 16),
              Text('Select Color'),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['purple', 'blue', 'green', 'orange', 'pink']
                    .map((color) {
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getColorFromString(color),
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
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
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  final userId = userProvider.userId;

                  if (userId != null) {
                    // Add group with user ID
                    _dataService.addGroup(nameController.text, selectedColor);
                    Navigator.pop(context);
                    
                    // Reload groups
                    await _loadGroups();
                  }
                }
              },
              child: Text('Create'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context, GroupModel group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share this link with your team:'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                group.shareLink,
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Link copied to clipboard!')),
                );
              },
              icon: Icon(Icons.copy),
              label: Text('Copy Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}