import 'package:flutter/material.dart';
import 'profile_page.dart'; // Make sure this file exists

class User {
  final String id;
  final String name;
  final String location;
  final String photoUrl;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final String availability;

  User({
    required this.id,
    required this.name,
    required this.location,
    required this.photoUrl,
    required this.skillsOffered,
    required this.skillsWanted,
    required this.availability,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  DateTime? _lastBackPressTime;

  final List<User> _users = [
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
    User(
      id: '3',
      name: 'James Wilson',
      location: 'Chicago',
      photoUrl: 'https://placehold.co/150?text=JW',
      skillsOffered: ['JavaScript', 'React'],
      skillsWanted: ['Flutter', 'Figma'],
      availability: 'Evenings',
    ),
  ];

  List<User> get _filteredUsers {
    return _users.where((user) {
      final searchText = _searchController.text.toLowerCase();
      final matchesSearch = searchText.isEmpty ||
          user.skillsOffered.any((skill) => skill.toLowerCase().contains(searchText)) ||
          user.skillsWanted.any((skill) => skill.toLowerCase().contains(searchText));

      final matchesAvailability =
          _selectedFilter == 'All' || user.availability == _selectedFilter;

      return matchesSearch && matchesAvailability;
    }).toList();
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Press back again to exit the app')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skill Swap', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by skill...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedFilter,
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Availability')),
                  DropdownMenuItem(value: 'Weekdays', child: Text('Weekdays')),
                  DropdownMenuItem(value: 'Weekends', child: Text('Weekends')),
                  DropdownMenuItem(value: 'Evenings', child: Text('Evenings')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                },
                isExpanded: true,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredUsers.length,
            itemBuilder: (context, index) {
              final user = _filteredUsers[index];
              return _buildUserCard(user);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(user.location, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Offers: ${user.skillsOffered.join(', ')}',
                          style: TextStyle(color: Colors.green[800])),
                      const SizedBox(height: 4),
                      Text('Wants: ${user.skillsWanted.join(', ')}',
                          style: TextStyle(color: Colors.blue[800])),
                    ],
                  ),
                ),
                Chip(
                  label: Text(user.availability),
                  backgroundColor: Colors.orange[100],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showRequestDialog(user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Request Swap', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Request swap with ${user.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                items: ['Flutter', 'UI Design'].map((skill) {
                  return DropdownMenuItem(
                    value: skill,
                    child: Text(skill),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Your skill to offer'),
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                items: user.skillsWanted.map((skill) {
                  return DropdownMenuItem(
                    value: skill,
                    child: Text(skill),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Skill you want'),
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Message (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request sent to ${user.name}')),
                );
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
