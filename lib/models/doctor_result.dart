// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'doctor_result.freezed.dart';
//
// @freezed
// class DoctorResult with _$DoctorResult {
//   factory DoctorResult({
//     required String name,
//     String? content,
//     required DateTime dateTime,
//     required ResultStatus status,
//     required String imageUrl,
//   }) = _DoctorResult;
// }

class DoctorResult {
  String name;
  String? content;
  DateTime dateTime;
  ResultStatus status;
  String imageUrl;

  // Constructor
  DoctorResult({
    required this.name,
    this.content,
    required this.dateTime,
    required this.status,
    required this.imageUrl,
  });

  // Factory method to create a DoctorResult instance from a Map
  factory DoctorResult.fromMap(Map<String, dynamic> map) {
    return DoctorResult(
      name: map['name'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
      status: map['status'],
      imageUrl: map['imageUrl'],
    );
  }

  // Method to convert DoctorResult instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': content,
      'dateTime': dateTime.toIso8601String(),
      'status': status.toString(),
      'imageUrl': imageUrl,
    };
  }
}

List<DoctorResult> doctorResultListFromJsonList(
    List<Map<String, dynamic>> json) {
  return json.map((vendorData) {
    return DoctorResult(
      name: vendorData["attributes"]["name"],
      content: vendorData["attributes"]["content"],
      dateTime: DateTime.parse(vendorData["attributes"]["data_time"]),
      status: stringToEnum[vendorData["attributes"]["status"]] ??
          ResultStatus.pending,
      imageUrl: vendorData["attributes"]["image"]["data"]["attributes"]["url"],
    );
  }).toList();
}

enum ResultStatus { pending, complete }

const stringToEnum = {
  'pending': ResultStatus.pending,
  'complete': ResultStatus.complete,
};
