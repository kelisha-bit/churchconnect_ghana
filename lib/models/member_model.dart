class MemberModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String membershipStatus;
  final String membershipType;
  final String? ministry;
  final String? department;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? occupation;
  final String? maritalStatus;
  final String? baptismStatus;
  final DateTime joinDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.membershipStatus,
    required this.membershipType,
    this.ministry,
    this.department,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.country,
    this.occupation,
    this.maritalStatus,
    this.baptismStatus,
    required this.joinDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileImageUrl: json['profile_image_url'],
      membershipStatus: json['membership_status'] ?? 'active',
      membershipType: json['membership_type'] ?? 'visitor',
      ministry: json['ministry'],
      department: json['department'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      occupation: json['occupation'],
      maritalStatus: json['marital_status'],
      baptismStatus: json['baptism_status'],
      joinDate:
          DateTime.parse(json['join_date'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'membership_status': membershipStatus,
      'membership_type': membershipType,
      'ministry': ministry,
      'department': department,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'occupation': occupation,
      'marital_status': maritalStatus,
      'baptism_status': baptismStatus,
      'join_date': joinDate.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';

  String get displayMinistry =>
      ministry?.replaceAll('_', ' ').toUpperCase() ?? 'N/A';

  String get displayDepartment =>
      department?.replaceAll('_', ' ').toUpperCase() ?? 'N/A';

  String get displayMembershipType =>
      membershipType.replaceAll('_', ' ').toUpperCase();
}
