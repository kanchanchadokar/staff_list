class StaffModel {
  int? id;
  String name;
  String email;
  String number;
  String position;

  StaffModel({this.id, required this.name,required this.email, required this.number, required this.position});

  // Convert a Employee object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
      'position': position,
    };
  }

  // Extract a Employee object from a Map object
  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      number: map['number'],
      position: map['position'],
    );
  }
}
