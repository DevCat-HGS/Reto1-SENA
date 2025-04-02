class Evaluation {
  final String id;
  final String studentId;
  final String courseId;
  final String title;
  final String type; // 'quiz', 'proyecto', 'taller', etc.
  double score;
  String status; // 'pendiente', 'calificado'
  String? feedback;
  List<String> evidenceUrls;
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
    this.evidenceUrls = const [],
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
      'evidenceUrls': evidenceUrls,
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
      evidenceUrls: List<String>.from(map['evidenceUrls'] ?? []),
      date: DateTime.parse(map['date']),
    );
  }
}