import 'package:duha_app/features/groups/data/models/group_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';

class GroupSettingsSheet extends StatefulWidget {
  final Group group;
  final ScrollController scrollController;
  final DataService dataService;

  const GroupSettingsSheet({
    super.key,
    required this.group,
    required this.scrollController,
    required this.dataService,
  });

  @override
  State<GroupSettingsSheet> createState() => _GroupSettingsSheetState();
}

class _GroupSettingsSheetState extends State<GroupSettingsSheet> {
  late TextEditingController _nameController;
  late String _selectedIcon;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _selectedIcon = widget.group.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group name cannot be empty')),
      );
      return;
    }

    // Update group via data service
    final updatedGroup = widget.group.copyWith(
      name: _nameController.text.trim(),
      color: _selectedIcon,
    );

    // Call your data service method to update the group
     await widget.dataService.updatedGroup(updatedGroup);

    setState(() {
      _isEditing = false;
    });

    
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      case 'amber':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  Future<void> _deleteGroup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
          'Are you sure you want to delete "${widget.group.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Call your data service method to delete the group
      // await widget.dataService.deleteGroup(widget.group.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group deleted')),
      );
    }
  }

  Future<String> _getUserName(String userId) async {
    return widget.dataService.getUserById(userId).name ?? "NO";
  }

Future<void> _removeMember(String groupId, String memberId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove $memberId from this group?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Remove member via data service
       widget.dataService.leaveGroup(groupId,memberId);
      
      // Update UI
      setState(() {
        // This will rebuild the widget and fetch the updated group
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$memberId removed from group')),
        );
      }
    }
  }

  void _showColorPicker() {
    final colors = {
      'purple': Colors.purple,
      'blue': Colors.blue,
      'red': Colors.red,
      'green': Colors.green,
      'orange': Colors.orange,
      'pink': Colors.pink,
      'teal': Colors.teal,
      'amber': Colors.amber,
    };

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final colorName = colors.keys.elementAt(index);
                final color = colors[colorName]!;
                final isSelected = _selectedIcon == colorName;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIcon = colorName;
                      _isEditing = true;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 32,
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        controller: widget.scrollController,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          const Text(
            'Group Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Group color
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Group Color'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getColorFromName(_selectedIcon),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _showColorPicker,
          ),
          const Divider(),

          // Group Name
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Group Name'),
            subtitle: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter group name',
              ),
              onChanged: (value) {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          ),
          const Divider(),

          // Save button (shown when editing)
          if (_isEditing) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 16),
          ],

          // Group Info
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Created'),
            subtitle: Text(
              '${widget.group.createdAt?.toLocal().toString().split(' ')[0] ?? 'Unknown'}',
            ),
          ),
          const Divider(),

          // Task Count
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Members'),
            subtitle: Text('${widget.group.memberIds?.length ?? 0} members'),
          ),

          ...?widget.group.memberIds?.map((memberId) {
            return FutureBuilder<String>(
              future: _getUserName(memberId),
              builder: (context, snapshot) {
                final userName = snapshot.data ?? 'Loading...';
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 56, right: 16),
                  leading: CircleAvatar(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(userName),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () => _removeMember(widget.group.id,memberId),
                  ),
                );
              },
            );
          }).toList(),

          const Divider(),

          const SizedBox(height: 24),

          // Delete Group
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text(
              'Delete Group',
              style: TextStyle(color: Colors.red),
            ),
            onTap: _deleteGroup,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
