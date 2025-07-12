import 'package:flutter/material.dart';
import 'package:skill_swap_app/models/user.dart';
import 'package:skill_swap_app/screen/home_page.dart' hide User;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final List<User> _pendingVerifications = [
    User(
      id: '101',
      name: 'New User 1',
      location: 'Unknown',
      photoUrl: 'https://placehold.co/150?text=NU1',
      skillsOffered: ['Unverified Skill'],
      skillsWanted: ['Unverified Skill'],
      availability: 'Flexible',
    ),
  ];
  final List<User> _allUsers = [
    User(
      id: '1',
      name: 'Alex Johnson',
      location: 'New York',
      photoUrl: 'https://placehold.co/150?text=AJ',
      skillsOffered: ['Flutter', 'UI Design'],
      skillsWanted: ['Python', 'Photoshop'],
      availability: 'Weekends',
    ),
    User(
      id: '2',
      name: 'Sarah Miller',
      location: 'San Francisco',
      photoUrl: 'https://placehold.co/150?text=SM',
      skillsOffered: ['Python', 'Data Analysis'],
      skillsWanted: ['Swift', 'UI/UX'],
      availability: 'Weekdays',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: _buildSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'User Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Skill Verification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildUserManagementScreen();
      case 1:
        return _buildSkillVerificationScreen();
      case 2:
        return _buildAnalyticsScreen();
      default:
        return _buildUserManagementScreen();
    }
  }

  Widget _buildUserManagementScreen() {
    return ListView.builder(
      itemCount: _allUsers.length,
      itemBuilder: (context, index) {
        final user = _allUsers[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            title: Text(user.name),
            subtitle: Text(user.location),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditUserDialog(user);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(user);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillVerificationScreen() {
    return ListView.builder(
      itemCount: _pendingVerifications.length,
      itemBuilder: (context, index) {
        final user = _pendingVerifications[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(user.location),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Offers: ${user.skillsOffered.join(', ')}'),
                Text('Seeks: ${user.skillsWanted.join(', ')}'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      child: const Text('Reject'),
                      onPressed: () {
                        _rejectVerification(user);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      child: const Text('Approve'),
                      onPressed: () {
                        _approveVerification(user);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 100, color: Colors.blueGrey),
          SizedBox(height: 20),
          Text(
            'App Analytics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Total Users: 42',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(
            'Active Today: 18',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(
            'Swaps This Month: 127',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(User user) {
    TextEditingController nameController = TextEditingController(text: user.name);
    TextEditingController locationController = TextEditingController(text: user.location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveUserChanges(user, nameController.text, locationController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveUserChanges(User user, String newName, String newLocation) {
    setState(() {
      // In a real app, you would call your API to update the user
      user.name = newName;
      user.location = newLocation;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User updated successfully')),
    );
  }

  void _showDeleteConfirmation(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(user);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(User user) {
    setState(() {
      _allUsers.removeWhere((u) => u.id == user.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name} has been deleted')),
    );
  }

  void _approveVerification(User user) {
    setState(() {
      _pendingVerifications.removeWhere((u) => u.id == user.id);
      // Add to verified users in a real app
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name}\'s skills have been approved')),
    );
  }

  void _rejectVerification(User user) {
    setState(() {
      _pendingVerifications.removeWhere((u) => u.id == user.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name}\'s skills have been rejected')),
    );
  }
}