class Attendance {
  final String id;
  final String studentId;
  final DateTime date;
  final String status; // 'presente', 'ausente', 'tardanza'
  final String? justification;

  Attendance({
    required this.id,
    required this.studentId,
    required this.date,
    required this.status,
    this.justification,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'status': status,
      'justification': justification,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentId: map['studentId'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      justification: map['justification'],
    );
  }
}