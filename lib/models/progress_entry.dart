class ProgressEntry {
  final String id;
  final String patientId;
  final DateTime date;
  final String selectedAssessmentScale;
  final double shoulderROM;
  final double kneeROM;
  final double elbowROM;
  final double hipROM;
  final String notes;

  ProgressEntry({
    required this.id,
    required this.patientId,
    required this.date,
    required this.selectedAssessmentScale,
    this.shoulderROM = 0.0,
    this.kneeROM = 0.0,
    this.elbowROM = 0.0,
    this.hipROM = 0.0,
    this.notes = '',
  });

  // Convert ProgressEntry to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'date': date.millisecondsSinceEpoch,
      'selectedAssessmentScale': selectedAssessmentScale,
      'shoulderROM': shoulderROM,
      'kneeROM': kneeROM,
      'elbowROM': elbowROM,
      'hipROM': hipROM,
      'notes': notes,
    };
  }

  // Create ProgressEntry from Map (database row)
  factory ProgressEntry.fromMap(Map<String, dynamic> map) {
    return ProgressEntry(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      selectedAssessmentScale: map['selectedAssessmentScale'] ?? '',
      shoulderROM: map['shoulderROM']?.toDouble() ?? 0.0,
      kneeROM: map['kneeROM']?.toDouble() ?? 0.0,
      elbowROM: map['elbowROM']?.toDouble() ?? 0.0,
      hipROM: map['hipROM']?.toDouble() ?? 0.0,
      notes: map['notes'] ?? '',
    );
  }

  // Create a copy with updated values
  ProgressEntry copyWith({
    String? id,
    String? patientId,
    DateTime? date,
    String? selectedAssessmentScale,
    double? shoulderROM,
    double? kneeROM,
    double? elbowROM,
    double? hipROM,
    String? notes,
  }) {
    return ProgressEntry(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      selectedAssessmentScale: selectedAssessmentScale ?? this.selectedAssessmentScale,
      shoulderROM: shoulderROM ?? this.shoulderROM,
      kneeROM: kneeROM ?? this.kneeROM,
      elbowROM: elbowROM ?? this.elbowROM,
      hipROM: hipROM ?? this.hipROM,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'ProgressEntry{id: $id, patientId: $patientId, date: $date}';
  }
}
