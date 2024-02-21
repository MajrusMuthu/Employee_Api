class DataModel {
  final String? id;
  final String name;
  final String email;
  final String gender;
  final String designation;
  final String address;
  final String phoneNumber;
  late final String imageUrl; 

  DataModel({
    this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.designation,
    required this.address,
    required this.phoneNumber,
    required this.imageUrl
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['_id'] ?? 'NO ID', 
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      designation: json['designation'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      imageUrl: json['imageUrl'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
       'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'designation': designation,
      'address': address,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }
}
