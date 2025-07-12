import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _skillOfferedController = TextEditingController();
  final TextEditingController _skillWantedController = TextEditingController();
  List<String> _skillsOffered = [];
  List<String> _skillsWanted = [];
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    const String apiUrl = 'http://192.168.141.225:5000/api/users/me';

    try {
      String? token = await _storage.read(key: 'auth_token');

      if (token == null) {
        throw Exception('No token found.');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _locationController.text = userData['location'] ?? '';
          _skillsOffered = List<String>.from(userData['skillsOffered'] ?? []);
          _skillsWanted = List<String>.from(userData['skillsWanted'] ?? []);
        });
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving profile...')),
      );

      try {
        String? token = await _storage.read(key: 'auth_token');

        if (token == null) {
          throw Exception('No token found.');
        }

        await saveProfileData(
          _nameController.text,
          _locationController.text,
          _skillsOffered,
          _skillsWanted,
          token,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> saveProfileData(
      String name,
      String location,
      List<String> skillsOffered,
      List<String> skillsWanted,
      String token,
      ) async {
    const String apiUrl = 'http://192.168.141.225:5000/api/users/me';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'location': location,
        'skillsOffered': skillsOffered,
        'skillsWanted': skillsWanted,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save profile: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildPersonalInfoSection(),
              const SizedBox(height: 24),
              _buildSkillsSection('Skills I Offer', _skillsOffered, _skillOfferedController, true),
              const SizedBox(height: 24),
              _buildSkillsSection('Skills I Want', _skillsWanted, _skillWantedController, false),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://placehold.co/150?text=AJ'),
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            _locationController.text,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(String title, List<String> skillsList,
      TextEditingController controller, bool isOffered) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Add ${isOffered ? 'offered' : 'wanted'} skill',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addSkill(controller, isOffered),
                      ),
                    ),
                    onFieldSubmitted: (_) => _addSkill(controller, isOffered),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (skillsList.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skillsList.map((skill) {
                  return Chip(
                    label: Text(skill),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeSkill(skill, isOffered),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Save Profile', style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  void _addSkill(TextEditingController controller, bool isOffered) {
    if (controller.text.isNotEmpty) {
      setState(() {
        if (isOffered) {
          _skillsOffered.add(controller.text.trim());
        } else {
          _skillsWanted.add(controller.text.trim());
        }
        controller.clear();
      });
    }
  }

  void _removeSkill(String skill, bool isOffered) {
    setState(() {
      if (isOffered) {
        _skillsOffered.remove(skill);
      } else {
        _skillsWanted.remove(skill);
      }
    });
  }
}
