class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final String? birthDate;
  final double weightLost;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.birthDate,
    this.weightLost = 0,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      phone: json['phone'],
      birthDate: json['birth_date'],
      weightLost: double.tryParse(json['weight_lost']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar': avatar,
    'phone': phone,
    'birth_date': birthDate,
    'weight_lost': weightLost,
  };
}