import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  final String userRole;
  
  const GradesPage({super.key, required this.userRole});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final List<Map<String, dynamic>> _courses = [
    {
      'id': '1',
      'name': 'Desarrollo de Software',
      'code': 'DS001',
      'evaluations': [
        {
          'id': '1',
          'title': 'Proyecto Final',
          'type': 'proyecto',
          'score': 4.5,
          'status': 'calificado',
          'feedback': 'Excelente trabajo en el desarrollo del proyecto',
          'date': DateTime.now(),
        },
        {
          'id': '2',
          'title': 'Quiz Módulo 1',
          'type': 'quiz',
          'score': 4.0,
          'status': 'calificado',
          'feedback': 'Buen manejo de los conceptos básicos',
          'date': DateTime.now(),
        },
      ],
    },
    {
      'id': '2',
      'name': 'Bases de Datos',
      'code': 'BD001',
      'evaluations': [
        {
          'id': '3',
          'title': 'Taller SQL',
          'type': 'taller',
          'score': 3.8,
          'status': 'calificado',
          'feedback': 'Mejorar la optimización de consultas',
          'date': DateTime.now(),
        },
      ],
    },
  ];

  void _showEvaluationDetails(Map<String, dynamic> evaluation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(evaluation['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${evaluation['type']}'),
            Text('Estado: ${evaluation['status']}'),
            Text('Calificación: ${evaluation['score']}'),
            if (evaluation['feedback']?.isNotEmpty ?? false)
              Text('Retroalimentación: ${evaluation['feedback']}'),
            Text(
              'Fecha: ${evaluation['date'].day}/${evaluation['date'].month}/${evaluation['date'].year}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Calificaciones'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, courseIndex) {
          final course = _courses[courseIndex];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(course['name']),
              subtitle: Text('Código: ${course['code']}'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: course['evaluations'].length,
                  itemBuilder: (context, evalIndex) {
                    final evaluation = course['evaluations'][evalIndex];
                    return ListTile(
                      title: Text(evaluation['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo: ${evaluation['type']}'),
                          Text('Calificación: ${evaluation['score']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () => _showEvaluationDetails(evaluation),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}