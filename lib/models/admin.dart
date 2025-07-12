class Admin {
  final String id;
  final String name;
  final String email;
  final String role;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}