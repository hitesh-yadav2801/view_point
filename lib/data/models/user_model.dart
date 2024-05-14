class UserModel {
  final String name;
  final String phoneNumber;
  final bool registrationFlag;
  final bool isAdmin;

  UserModel({
    required this.name,
    required this.phoneNumber,
    this.registrationFlag = false,
    this.isAdmin = false,
  });

  UserModel copyWith({String? name, String? phoneNumber, bool? registrationFlag, bool? isAdmin}) {
    return UserModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      registrationFlag: registrationFlag ?? this.registrationFlag,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        phoneNumber = map['phoneNumber'],
        registrationFlag = map['registrationFlag'] as bool,
        isAdmin = map['isAdmin'] as bool;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'registrationFlag': registrationFlag,
      'isAdmin': isAdmin
    };
  }

  @override
  String toString() {
    return 'UserModel{name: $name, phoneNumber: $phoneNumber}';
  }
}
