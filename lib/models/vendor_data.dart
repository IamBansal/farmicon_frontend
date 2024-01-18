// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'vendor_data.freezed.dart';
//
// @freezed
// class VendorData with _$VendorData {
//   factory VendorData({
//     required String name,
//     required String address,
//     required int countryCode,
//     required int phoneNumber,
//     required String imageUrl,
//   }) = _VendorData;
// }

class VendorData {
  String name;
  String address;
  int countryCode;
  int phoneNumber;
  String imageUrl;

  // Constructor
  VendorData({
    required this.name,
    required this.address,
    required this.countryCode,
    required this.phoneNumber,
    required this.imageUrl,
  });

  // Factory method to create a VendorData instance from a Map
  factory VendorData.fromMap(Map<String, dynamic> map) {
    return VendorData(
      name: map['name'],
      address: map['address'],
      countryCode: map['countryCode'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
    );
  }

  // Method to convert VendorData instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }
}

List<VendorData> vendorDataListFromJsonList(List<Map<String, dynamic>> json) {
  return json.map((vendorData) {
    return VendorData(
      name: vendorData["attributes"]["name"],
      address: vendorData["attributes"]["address"],
      countryCode: vendorData["attributes"]["country_code"],
      phoneNumber: int.parse(vendorData["attributes"]["phone_number"]),
      imageUrl: vendorData["attributes"]["image"]["data"]["attributes"]["url"],
    );
  }).toList();
}
