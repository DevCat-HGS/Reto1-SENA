class Evidence {
  final String id;
  final String type; // 'documento', 'imagen'
  final String status; // 'pendiente_revision', 'aprobado', 'rechazado'
  final DateTime uploadDate;
  final String? comments;

  Evidence({
    required this.id,
    required this.type,
    this.status = 'pendiente_revision',
    required this.uploadDate,
    this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'uploadDate': uploadDate.toIso8601String(),
      'comments': comments,
    };
  }

  factory Evidence.fromMap(Map<String, dynamic> map) {
    return Evidence(
      id: map['id'],
      type: map['type'],
      status: map['status'] ?? 'pendiente_revision',
      uploadDate: DateTime.parse(map['uploadDate']),
      comments: map['comments'],
    );
  }
}

class Evaluation {
  final String id;
  final String studentId;
  final String courseId;
  final String title;
  final String type; // 'quiz', 'proyecto', 'taller', etc.
  double score;
  String status; // 'pendiente', 'en_revision', 'calificado'
  String? feedback;
  List<Evidence> evidences;
  final DateTime date;

  Evaluation({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.title,
    required this.type,
    this.score = 0.0,
    this.status = 'pendiente',
    this.feedback,
    this.evidences = const [],
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'title': title,
      'type': type,
      'score': score,
      'status': status,
      'feedback': feedback,
      'evidences': evidences.map((e) => e.toMap()).toList(),
      'date': date.toIso8601String(),
    };
  }

  factory Evaluation.fromMap(Map<String, dynamic> map) {
    return Evaluation(
      id: map['id'],
      studentId: map['studentId'],
      courseId: map['courseId'],
      title: map['title'],
      type: map['type'],
      score: map['score'],
      status: map['status'] ?? 'pendiente',
      feedback: map['feedback'],
      evidences: (map['evidences'] as List<dynamic>?)?.map((e) => Evidence.fromMap(e as Map<String, dynamic>)).toList() ?? [],
      date: DateTime.parse(map['date']),
    );
  }
}