import 'package:flutter/material.dart';

import '../models/evaluation_model.dart';

class EvaluationPage extends StatefulWidget {
  final String userRole;
  
  const EvaluationPage({super.key, required this.userRole});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final List<Evaluation> _evaluations = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvaluations();
  }

  void _loadEvaluations() {
    // Simular carga de evaluaciones
    setState(() {
      _evaluations.add(
        Evaluation(
          id: '1',
          studentId: 'student1',
          courseId: 'course1',
          title: 'Proyecto Final',
          type: 'proyecto',
          score: 0,
          status: 'pendiente',
          evidences: [],
          date: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluaciones'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: _evaluations.length,
        itemBuilder: (context, index) {
          final evaluation = _evaluations[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(evaluation.title),
              subtitle: Text('Tipo: ${evaluation.type}\nEstado: ${evaluation.status}'),
              trailing: evaluation.status == 'calificado'
                  ? Text(evaluation.score.toString())
                  : null,
              onTap: () => _showEvaluationDetails(evaluation),
            ),
          );
        },
      ),
      floatingActionButton: widget.userRole == 'instructor'
          ? FloatingActionButton(
              onPressed: _showAddEvaluationDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddEvaluationDialog() {
    String type = 'quiz';
    _titleController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Evaluación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ingrese el título de la evaluación',
              ),
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
              if (_titleController.text.isNotEmpty) {
                setState(() {
                  _evaluations.add(
                    Evaluation(
                      id: DateTime.now().toString(),
                      studentId: 'student1', // Temporal
                      courseId: 'course1', // Temporal
                      title: _titleController.text,
                      type: type,
                      score: 0,
                      status: 'pendiente',
                      evidences: [],
                      date: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showGradeDialog(Evaluation evaluation) {
    _scoreController.text = evaluation.score.toString();
    _feedbackController.text = evaluation.feedback ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calificar Evaluación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _scoreController,
              decoration: const InputDecoration(
                labelText: 'Calificación',
                hintText: 'Ingrese una nota de 0 a 5',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Retroalimentación',
                hintText: 'Ingrese sus comentarios',
              ),
              maxLines: 3,
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
              final score = double.tryParse(_scoreController.text) ?? 0.0;
              if (score >= 0 && score <= 5) {
                setState(() {
                  evaluation.score = score;
                  evaluation.feedback = _feedbackController.text;
                  evaluation.status = 'calificado';
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

  void _showEvaluationDetails(Evaluation evaluation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(evaluation.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${evaluation.type}'),
            Text('Estado: ${evaluation.status}'),
            if (evaluation.status == 'calificado') ...[              
              Text('Calificación: ${evaluation.score}'),
              if (evaluation.feedback?.isNotEmpty ?? false)
                Text('Retroalimentación: ${evaluation.feedback}'),
            ],
            Text(
              'Fecha: ${evaluation.date.day}/${evaluation.date.month}/${evaluation.date.year}',
            ),
            const SizedBox(height: 16),
            const Text('Evidencias:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (evaluation.evidences.isEmpty)
              const Text('No hay evidencias adjuntas')
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: evaluation.evidences.length,
                itemBuilder: (context, index) {
                  final evidence = evaluation.evidences[index];
                  return ListTile(
                    title: Text('Evidencia ${index + 1}'),
                    subtitle: Text('Tipo: ${evidence.type}\nEstado: ${evidence.status}'),
                  );
                },
              ),
          ],
        ),
        actions: [
          if (widget.userRole == 'instructor' && evaluation.status != 'calificado')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showGradeDialog(evaluation);
              },
              child: const Text('Calificar'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scoreController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}