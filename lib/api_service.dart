import 'dart:convert';
import 'package:http/http.dart' as http;

// Define your API endpoint
const String apiUrl = 'https://yourapi.com/saveProfile'; // Replace with your actual API URL

Future<void> saveProfileData(String name, String location, List<String> skillsOffered, List<String> skillsWanted) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'location': location,
      'skillsOffered': skillsOffered,
      'skillsWanted': skillsWanted,
    }),
  );

  if (response.statusCode == 200) {
    // Successfully saved
    print('Profile saved successfully!');
  } else {
    // Handle error
    throw Exception('Failed to save profile: ${response.body}');
  }
}