class User {
  final String id;
  late final String name;
  late final String location;
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

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      photoUrl: json['photoUrl'] as String,
      skillsOffered: List<String>.from(json['skillsOffered']),
      skillsWanted: List<String>.from(json['skillsWanted']),
      availability: json['availability'] as String,
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'photoUrl': photoUrl,
      'skillsOffered': skillsOffered,
      'skillsWanted': skillsWanted,
      'availability': availability,
    };
  }
}