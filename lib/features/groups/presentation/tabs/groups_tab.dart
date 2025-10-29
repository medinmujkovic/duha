import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/groups/presentation/screens/group_detail_screen.dart';
import 'package:duha_app/features/projects/data/models/project_model/project_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsTab extends ConsumerStatefulWidget {
  const GroupsTab({super.key});

  @override
  ConsumerState<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends ConsumerState<GroupsTab>
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
    // defer reading providers until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroups();
    });
  }

  Future<void> _loadGroups() async {
    final user = ref.read(userProvider);
    final userId = user?.id; 

    if (userId == null) {
      if(!mounted)return;
      setState(() {
        _error = 'User not authenticated';
        _isLoading = false;
      });
      return;
    }

    if(!mounted)return;
      setState(() {
        _isLoading = true;
        _error = null;
      });

    try {
      // Replace this with your actual API call
      
      // For now, using local data service
      final groups = _dataService.getUserGroups(userId);

      if (!mounted) return;
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGroups,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGroups,
      child: ListView(
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
          if (_groups.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No groups yet. Create one to get started!',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ..._groups.map((group) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final user = ref.read(userProvider);
                  final userId = user?.id;

                  if (userId != null) {
                    // Add group with user ID
                    _dataService.addGroup(nameController.text,userId,selectedColor);
                    if (mounted) Navigator.pop(context);
                    
                    // Reload groups
                    await _loadGroups();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
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