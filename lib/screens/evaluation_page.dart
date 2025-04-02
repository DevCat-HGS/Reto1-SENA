import 'package:flutter/material.dart';
import '../models/evaluation_model.dart';

class EvaluationPage extends StatefulWidget {
  final String userRole;
  
  const EvaluationPage({super.key, required this.userRole});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final List<Map<String, dynamic>> _evaluations = [
    // Lista de evaluaciones con evidencias

    {
      'id': '1',
      'title': 'Proyecto Final',
      'type': 'proyecto',
      'date': DateTime.now(),
      'status': 'pendiente',
      'evidencias': []
    },
    {
      'id': '2',
      'title': 'Quiz Módulo 1',
      'type': 'quiz',
      'date': DateTime.now(),
      'status': 'calificado',
      'evidencias': []
    },
  ];

  void _showAddEvaluationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String type = 'quiz';
        return AlertDialog(
          title: const Text('Nueva Evaluación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ingrese el título de la evaluación',
                ),
                onChanged: (value) => title = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Evaluación',
                ),
                items: const [
                  DropdownMenuItem(value: 'quiz', child: Text('Quiz')),
                  DropdownMenuItem(value: 'proyecto', child: Text('Proyecto')),
                  DropdownMenuItem(value: 'taller', child: Text('Taller')),
                ],
                onChanged: (value) => type = value!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    _evaluations.add({
                      'id': DateTime.now().toString(),
                      'title': title,
                      'type': type,
                      'date': DateTime.now(),
                      'status': 'pendiente',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  void _showGradeDialog(Map<String, dynamic> evaluation) {
    double score = 0.0;
    String feedback = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calificar Evaluación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Calificación',
                hintText: 'Ingrese una nota de 0 a 5',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => score = double.tryParse(value) ?? 0.0,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Retroalimentación',
                hintText: 'Ingrese sus comentarios',
              ),
              maxLines: 3,
              onChanged: (value) => feedback = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (score >= 0 && score <= 5) {
                setState(() {
                  evaluation['score'] = score;
                  evaluation['feedback'] = feedback;
                  evaluation['status'] = 'calificado';
                });
                Navigator.pop(context);
                _showEvaluationDetails(evaluation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La calificación debe estar entre 0 y 5'),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  bool get _isInstructor => widget.userRole == 'instructor';

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
            if (evaluation['status'] == 'calificado') ...[              
              Text('Calificación: ${evaluation['score']}'),
              if (evaluation['feedback']?.isNotEmpty ?? false)
                Text('Retroalimentación: ${evaluation['feedback']}'),
            ],
            Text(
              'Fecha: ${evaluation['date'].day}/${evaluation['date'].month}/${evaluation['date'].year}',
            ),
            const SizedBox(height: 16),
            if (_isInstructor && evaluation['status'] == 'pendiente')
              ElevatedButton(
                onPressed: () => _showGradeDialog(evaluation),
                child: const Text('Calificar'),
              ),
            if (_isInstructor && evaluation['status'] == 'calificado')
              ElevatedButton(
                onPressed: () => _showGradeDialog(evaluation),
                child: const Text('Modificar Calificación'),
              ),
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Subir Evidencia'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Seleccione el tipo de evidencia:'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context, 'documento');
                              },
                              icon: const Icon(Icons.description),
                              label: const Text('Documento'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context, 'imagen');
                              },
                              icon: const Icon(Icons.image),
                              label: const Text('Imagen'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    if (evaluation['evidencias'] == null) {
                      evaluation['evidencias'] = [];
                    }
                    evaluation['evidencias'].add({
                      'tipo': result,
                      'fecha': DateTime.now(),
                      'estado': 'pendiente_revision'
                    });
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Evidencia agregada correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Subir Evidencia'),
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
}