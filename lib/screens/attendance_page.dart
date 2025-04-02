import 'package:flutter/material.dart';
import '../models/course_model.dart';

class AttendancePage extends StatefulWidget {
  final String userRole;
  
  const AttendancePage({super.key, required this.userRole});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<Course> _courses = [
    Course(id: '1', name: 'Desarrollo de Software', code: 'DS001'),
    Course(id: '2', name: 'Bases de Datos', code: 'BD001'),
  ];

  String? _selectedCourseId;
  final List<Map<String, dynamic>> _students = [
    {'id': '1', 'name': 'Juan Pérez', 'email': 'jperez@sena.edu.co', 'status': 'presente'},
    {'id': '2', 'name': 'María García', 'email': 'mgarcia@sena.edu.co', 'status': 'presente'},
    {'id': '3', 'name': 'Carlos López', 'email': 'clopez@sena.edu.co', 'status': 'ausente'},
  ];

  final List<Map<String, dynamic>> _attendanceRecords = [];
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _justificationController = TextEditingController();

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  void _registerAttendance(String studentId, String status, [String? justification]) {
    if (_selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione un curso'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _attendanceRecords.add({
        'id': DateTime.now().toString(),
        'courseId': _selectedCourseId,
        'studentId': studentId,
        'date': _selectedDate,
        'status': status,
        'justification': justification,
      });
      
      final studentIndex = _students.indexWhere((s) => s['id'] == studentId);
      if (studentIndex != -1) {
        _students[studentIndex]['status'] = status;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Asistencia'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: widget.userRole == 'instructor' ? _buildInstructorView() : _buildStudentView(),
    );
  }

  Widget _buildInstructorView() {
    return SingleChildScrollView(
      child: Column(
      children: [
        Padding(
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
                onChanged: (String? value) {
                  setState(() {
                    _selectedCourseId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Cambiar Fecha'),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(student['name']),
                  subtitle: Text(student['email']),
                  trailing: DropdownButton<String>(
                    value: student['status'],
                    items: const [
                      DropdownMenuItem(value: 'presente', child: Text('Presente')),
                      DropdownMenuItem(value: 'ausente', child: Text('Ausente')),
                      DropdownMenuItem(value: 'tardanza', child: Text('Tardanza')),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        if (newValue == 'ausente') {
                          _showJustificationDialog(student['id']);
                        } else {
                          _registerAttendance(student['id'], newValue);
                        }
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              if (_selectedCourseId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor seleccione un curso'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              // Aquí se implementará la lógica para guardar la asistencia
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Asistencia guardada correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Guardar Asistencia'),
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildStudentView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
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
              onChanged: (String? value) {
                setState(() {
                  _selectedCourseId = value;
                });
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
          child: _selectedCourseId == null
              ? const Center(child: Text('Seleccione un curso para ver la asistencia'))
              : ListView.builder(
                  itemCount: _attendanceRecords.where(
                    (record) =>
                        record['studentId'] == '1' && // Simulando ID del estudiante actual
                        record['courseId'] == _selectedCourseId,
                  ).length,
                  itemBuilder: (context, index) {
                    final records = _attendanceRecords.where(
                      (record) =>
                          record['studentId'] == '1' && // Simulando ID del estudiante actual
                          record['courseId'] == _selectedCourseId,
                    ).toList();
                    final record = records[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            'Fecha: ${record['date'].day}/${record['date'].month}/${record['date'].year}'),
                        subtitle: Text('Estado: ${record['status']}'),
                        trailing: record['justification'] != null
                            ? IconButton(
                                icon: const Icon(Icons.info),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Justificación'),
                                      content: Text(record['justification']),
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
                    );
                  },
                ),
        ),
      ],
    ),
    );
  }

  void _showJustificationDialog(String studentId) {
    _justificationController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Justificación de Ausencia'),
        content: TextField(
          controller: _justificationController,
          decoration: const InputDecoration(
            labelText: 'Justificación',
            hintText: 'Ingrese la justificación de la ausencia',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _registerAttendance(
                studentId,
                'ausente',
                _justificationController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}