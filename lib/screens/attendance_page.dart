import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/attendance_model.dart';

class AttendancePage extends StatefulWidget {
  final String userRole;
  
  const AttendancePage({super.key, required this.userRole});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
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

  final List<Attendance> _attendanceRecords = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAttendanceRecords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAttendanceRecords() {
    // Simular carga de registros de asistencia
    setState(() {
      _attendanceRecords.addAll([
        Attendance(
          id: '1',
          studentId: '1',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'presente',
        ),
        Attendance(
          id: '2',
          studentId: '2',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'ausente',
          justification: 'Cita médica',
        ),
      ]);
    });
  }

  void _showJustificationDialog(String studentId) {
    final TextEditingController justificationController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Justificación de Inasistencia'),
        content: TextField(
          controller: justificationController,
          decoration: const InputDecoration(
            hintText: 'Ingrese la justificación',
            border: OutlineInputBorder(),
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
              if (justificationController.text.isNotEmpty) {
                _registerAttendance(studentId, 'ausente', justificationController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
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

    final attendance = Attendance(
      id: DateTime.now().toString(),
      studentId: studentId,
      date: _selectedDate,
      status: status,
      justification: justification,
    );

    setState(() {
      _attendanceRecords.add(attendance);
      final studentIndex = _students.indexWhere((s) => s['id'] == studentId);
      if (studentIndex != -1) {
        _students[studentIndex]['status'] = status;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Asistencia registrada correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Registro'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRegistrationTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildRegistrationTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Row(
            children: [
              const Text('Fecha: '),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
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
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(student['name'][0]),
                    ),
                    title: Text(student['name']),
                    subtitle: Text(student['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline),
                          color: student['status'] == 'presente' ? Colors.green : null,
                          onPressed: () => _registerAttendance(student['id'], 'presente'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          color: student['status'] == 'ausente' ? Colors.red : null,
                          onPressed: () => _showJustificationDialog(student['id']),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              itemCount: _attendanceRecords.length,
              itemBuilder: (context, index) {
                final attendance = _attendanceRecords[index];
                final student = _students.firstWhere(
                  (s) => s['id'] == attendance.studentId,
                  orElse: () => {'name': 'Estudiante no encontrado'},
                );
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: attendance.status == 'presente'
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        attendance.status == 'presente'
                            ? Icons.check
                            : Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(student['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha: ${attendance.date.day}/${attendance.date.month}/${attendance.date.year}',
                        ),
                        if (attendance.justification != null)
                          Text('Justificación: ${attendance.justification}'),
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
}