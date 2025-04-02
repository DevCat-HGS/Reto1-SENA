 import 'package:flutter/material.dart';
import '../models/evaluation_model.dart';
import '../models/course_model.dart';

class EvaluationPage extends StatefulWidget {
  final String userRole;
  
  const EvaluationPage({super.key, required this.userRole});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Course> _courses = [
    Course(id: '1', name: 'Desarrollo de Software', code: 'DS001'),
    Course(id: '2', name: 'Bases de Datos', code: 'BD001'),
  ];

  String? _selectedCourseId;
  final List<Evaluation> _evaluations = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxScoreController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEvaluations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _maxScoreController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _loadEvaluations() {
    setState(() {
      _evaluations.addAll([
        Evaluation(
          id: '1',
          studentId: 'student1',
          courseId: '1',
          title: 'Proyecto Final',
          type: 'proyecto',
          score: 4.5,
          status: 'calificado',
          evidences: [
            Evidence(
              id: '1',
              type: 'documento',
              status: 'aprobado',
              uploadDate: DateTime.now().subtract(const Duration(days: 5)),
              comments: 'Excelente trabajo',
            ),
          ],
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Evaluation(
          id: '2',
          studentId: 'student2',
          courseId: '1',
          title: 'Quiz Módulo 1',
          type: 'quiz',
          score: 0,
          status: 'pendiente',
          evidences: [],
          date: DateTime.now().add(const Duration(days: 2)),
        ),
      ]);
    });
  }

  void _showCreateEvaluationDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _maxScoreController.clear();
    _selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Evaluación'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _maxScoreController,
                decoration: const InputDecoration(
                  labelText: 'Puntaje Máximo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Fecha de Entrega: '),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _maxScoreController.text.isNotEmpty &&
                  _selectedCourseId != null) {
                final evaluation = Evaluation(
                  id: DateTime.now().toString(),
                  studentId: 'all',
                  courseId: _selectedCourseId!,
                  title: _titleController.text,
                  type: 'proyecto',
                  score: 0,
                  status: 'pendiente',
                  evidences: [],
                  date: _selectedDate,
                );

                setState(() {
                  _evaluations.add(evaluation);
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Evaluación creada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showEvidenceDialog(Evaluation evaluation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Evidencias'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                evaluation.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...evaluation.evidences.map(
                (evidence) => Card(
                  child: ListTile(
                    leading: Icon(
                      evidence.type == 'documento' ? Icons.description : Icons.image,
                      color: evidence.status == 'aprobado' ? Colors.green : Colors.orange,
                    ),
                    title: Text('Evidencia ${evidence.id}'),
                    subtitle: Text(
                      'Estado: ${evidence.status}\nFecha: ${evidence.uploadDate.day}/${evidence.uploadDate.month}/${evidence.uploadDate.year}',
                    ),
                    trailing: evidence.comments != null
                        ? IconButton(
                            icon: const Icon(Icons.comment),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Comentarios'),
                                  content: Text(evidence.comments!),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : null,
                  ),
                ),
              ),
              if (widget.userRole == 'aprendiz' && evaluation.status != 'calificado') ...[                
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implementar subida de evidencias
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función de subida de evidencias en desarrollo'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Subir Nueva Evidencia'),
                ),
              ],
            ],
          ),
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
        title: const Text('Evaluaciones'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingEvaluationsTab(),
          _buildHistoryTab(),
        ],
      ),
      floatingActionButton: widget.userRole == 'instructor'
          ? FloatingActionButton(
              onPressed: _showCreateEvaluationDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildPendingEvaluationsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedCourseId,
            decoration: const InputDecoration(
              labelText: 'Seleccionar Curso',
              border: OutlineInputBorder(),
            ),
            items: _courses.map((course) {
              return DropdownMenuItem(
                value: course.id,
                child: Text('${course.name} (${course.code})'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCourseId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _evaluations.where((e) => e.status != 'calificado').length,
              itemBuilder: (context, index) {
                final evaluation = _evaluations
                    .where((e) => e.status != 'calificado')
                    .toList()[index];
                if (_selectedCourseId != null && evaluation.courseId != _selectedCourseId) {
                  return const SizedBox.shrink();
                }
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(
                        evaluation.type == 'quiz' ? Icons.quiz : Icons.assignment,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(evaluation.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha de entrega: ${evaluation.date.day}/${evaluation.date.month}/${evaluation.date.year}',
                        ),
                        Text('Estado: ${evaluation.status}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.userRole == 'instructor') ...[                          
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Implementar edición de evaluación
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Función de edición en desarrollo'),
                                ),
                              );
                            },
                          ),
                        ] else ...[                          
                          IconButton(
                            icon: const Icon(Icons.upload_file),
                            onPressed: () => _showEvidenceDialog(evaluation),
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () => _showEvidenceDialog(evaluation),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedCourseId,
            decoration: const InputDecoration(
              labelText: 'Filtrar por Curso',
              border: OutlineInputBorder(),
            ),
            items: _courses.map((course) {
              return DropdownMenuItem(
                value: course.id,
                child: Text('${course.name} (${course.code})'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCourseId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _evaluations.where((e) => e.status == 'calificado').length,
              itemBuilder: (context, index) {
                final evaluation = _evaluations
                    .where((e) => e.status == 'calificado')
                    .toList()[index];
                if (_selectedCourseId != null && evaluation.courseId != _selectedCourseId) {
                  return const SizedBox.shrink();
                }
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        evaluation.score.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(evaluation.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha: ${evaluation.date.day}/${evaluation.date.month}/${evaluation.date.year}',
                        ),
                        if (evaluation.feedback != null)
                          Text('Retroalimentación: ${evaluation.feedback}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.folder_open),
                      onPressed: () => _showEvidenceDialog(evaluation),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}