class User {
  final int id;
  final String mobilePhone;
  final String fullName;
  final String? referralCode;

  User({
    required this.id,
    required this.mobilePhone,
    required this.fullName,
    this.referralCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      mobilePhone: json['mobilePhone'] ?? json['mobile_phone'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      referralCode: json['referralCode'] ?? json['referral_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobilePhone': mobilePhone,
      'fullName': fullName,
      'referralCode': referralCode,
    };
  }
}