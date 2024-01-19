class CropAnalysis {
  String image;
  String disease;
  String plant_name;
  String treatment;

  // Constructor
  CropAnalysis({
    required this.image,
    required this.disease,
    required this.plant_name,
    required this.treatment,
  });

  // Factory method to create an Address instance from a Map
  factory CropAnalysis.fromMap(Map<String, dynamic> map) {
    return CropAnalysis(
      image: map['image'],
      disease: map['disease'],
      plant_name: map['plant_name'],
      treatment: map['treatment'],
    );
  }

  // Method to convert Address instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'disease': disease,
      'plant_name': plant_name,
      'treatment': treatment,
    };
  }
}


CropAnalysis doctorResultList(Map<String, dynamic> map) {
    return CropAnalysis(
      image: map['image'],
      disease: map['disease'],
      plant_name: map['plant_name'],
      treatment: map['treatment'],
    );
}