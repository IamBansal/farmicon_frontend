// import 'package:freezed_annotation/freezed_annotation.dart';
//
// import 'address.dart';
//
// part 'user.freezed.dart';
//
// @freezed
// class User with _$User {
//   factory User({
//     required String name,
//     required String? email,
//     required String? phoneNumber,
//     required String imageUrl,
//     @Default([]) List<String> cropsHi,
//     @Default([]) List<String> cropsEn,
//     @Default(0) double areaQuantity,
//     @Default('acre') String areaUnit,
//     required Address address,
//   }) = _User;
// }


import 'address.dart';

class User {
  String name;
  String? email;
  String? phoneNumber;
  String imageUrl;
  List<String> cropsHi;
  List<String> cropsEn;
  double areaQuantity;
  String areaUnit;
  Address address;

  // Constructor
  User({
    required this.name,
    this.email,
    this.phoneNumber,
    required this.imageUrl,
    this.cropsHi = const [],
    this.cropsEn = const [],
    this.areaQuantity = 0,
    this.areaUnit = 'acre',
    required this.address,
  });

  // Factory method to create a User instance from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      cropsHi: List<String>.from(map['cropsHi'] ?? []),
      cropsEn: List<String>.from(map['cropsEn'] ?? []),
      areaQuantity: map['areaQuantity'] ?? 0.0,
      areaUnit: map['areaUnit'] ?? 'acre',
      address: Address.fromMap(map['address']),
    );
  }

  // Method to convert User instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'cropsHi': cropsHi,
      'cropsEn': cropsEn,
      'areaQuantity': areaQuantity,
      'areaUnit': areaUnit,
      'address': address.toMap(),
    };
  }
}
