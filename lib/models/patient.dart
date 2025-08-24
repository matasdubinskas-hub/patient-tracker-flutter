class Patient {
  final String id;
  final String name;
  final int age;
  final double weight;
  final String address;
  final String phoneNumber;
  final DateTime registrationDate;
  final String selectedAssessmentScale;
  final double shoulderROM;
  final double kneeROM;
  final double elbowROM;
  final double hipROM;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.address,
    required this.phoneNumber,
    required this.registrationDate,
    required this.selectedAssessmentScale,
    this.shoulderROM = 0.0,
    this.kneeROM = 0.0,
    this.elbowROM = 0.0,
    this.hipROM = 0.0,
  });

  // Convert Patient to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'address': address,
      'phoneNumber': phoneNumber,
      'registrationDate': registrationDate.millisecondsSinceEpoch,
      'selectedAssessmentScale': selectedAssessmentScale,
      'shoulderROM': shoulderROM,
      'kneeROM': kneeROM,
      'elbowROM': elbowROM,
      'hipROM': hipROM,
    };
  }

  // Create Patient from Map (database row)
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      registrationDate: DateTime.fromMillisecondsSinceEpoch(map['registrationDate'] ?? 0),
      selectedAssessmentScale: map['selectedAssessmentScale'] ?? '',
      shoulderROM: map['shoulderROM']?.toDouble() ?? 0.0,
      kneeROM: map['kneeROM']?.toDouble() ?? 0.0,
      elbowROM: map['elbowROM']?.toDouble() ?? 0.0,
      hipROM: map['hipROM']?.toDouble() ?? 0.0,
    );
  }

  // Create a copy with updated values
  Patient copyWith({
    String? id,
    String? name,
    int? age,
    double? weight,
    String? address,
    String? phoneNumber,
    DateTime? registrationDate,
    String? selectedAssessmentScale,
    double? shoulderROM,
    double? kneeROM,
    double? elbowROM,
    double? hipROM,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      registrationDate: registrationDate ?? this.registrationDate,
      selectedAssessmentScale: selectedAssessmentScale ?? this.selectedAssessmentScale,
      shoulderROM: shoulderROM ?? this.shoulderROM,
      kneeROM: kneeROM ?? this.kneeROM,
      elbowROM: elbowROM ?? this.elbowROM,
      hipROM: hipROM ?? this.hipROM,
    );
  }

  @override
  String toString() {
    return 'Patient{id: $id, name: $name, age: $age, registrationDate: $registrationDate}';
  }
}
