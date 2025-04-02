import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  final String userRole;
  
  const AttendancePage({super.key, required this.userRole});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<Map<String, dynamic>> _students = [
    {'id': '1', 'name': 'Juan Pérez', 'email': 'jperez@sena.edu.co', 'status': 'presente'},
    {'id': '2', 'name': 'María García', 'email': 'mgarcia@sena.edu.co', 'status': 'presente'},
    {'id': '3', 'name': 'Carlos López', 'email': 'clopez@sena.edu.co', 'status': 'ausente'},
  ];

  final List<Map<String, dynamic>> _attendanceRecords = [];

  DateTime _selectedDate = DateTime.now();

  void _registerAttendance(String studentId, String status, [String? justification]) {
    setState(() {
      _attendanceRecords.add({
        'id': DateTime.now().toString(),
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
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(student['name']),
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
      );
  }

  Widget _buildStudentView() {
    final studentAttendance = _attendanceRecords.where(
      (record) => record['studentId'] == '1', // Simulando ID del estudiante actual
    ).toList();

    return ListView.builder(
      itemCount: studentAttendance.length,
      itemBuilder: (context, index) {
        final record = studentAttendance[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Fecha: ${record['date'].toString().split(' ')[0]}'),
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
    );
  }

  void _showJustificationDialog(String studentId) {
    String justification = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Justificación de Ausencia'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Justificación',
            hintText: 'Ingrese la justificación de la ausencia',
          ),
          maxLines: 3,
          onChanged: (value) => justification = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _registerAttendance(studentId, 'ausente', justification);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}