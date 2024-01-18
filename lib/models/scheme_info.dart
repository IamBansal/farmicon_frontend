// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'scheme_info.freezed.dart';
//
// @freezed
// class SchemeInfo with _$SchemeInfo {
//   factory SchemeInfo({
//     required Map<String, String> title,
//     required String link,
//     required String imageUrl,
//     required DateTime createdAt,
//   }) = _SchemeInfo;
// }

class SchemeInfo {
  Map<String, String> title;
  String link;
  String imageUrl;
  DateTime createdAt;

  // Constructor
  SchemeInfo({
    required this.title,
    required this.link,
    required this.imageUrl,
    required this.createdAt,
  });

  // Factory method to create a SchemeInfo instance from a Map
  factory SchemeInfo.fromMap(Map<String, dynamic> map) {
    return SchemeInfo(
      title: Map<String, String>.from(map['title'] ?? {}),
      link: map['link'],
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Method to convert SchemeInfo instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'link': link,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}


List<SchemeInfo> schemeInfoListFromJsonList(List<Map<String, dynamic>> json) {
  return json.map((schemeInfo) {
    return SchemeInfo(
      title: {
        "hi": schemeInfo["attributes"]["hi"],
        "en": schemeInfo["attributes"]["en"],
      },
      createdAt: DateTime.parse(schemeInfo["attributes"]["createdAt"]),
      link: schemeInfo["attributes"]["link"],
      imageUrl: schemeInfo["attributes"]["image"]["data"]["attributes"]["url"],
    );
  }).toList();
}
