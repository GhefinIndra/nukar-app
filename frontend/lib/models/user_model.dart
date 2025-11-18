class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobilePhone;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobilePhone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      mobilePhone: json['mobilePhone'] ?? json['mobile_phone'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
