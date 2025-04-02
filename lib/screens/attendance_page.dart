import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<Map<String, dynamic>> _students = [
    {'id': '1', 'name': 'Juan Pérez', 'status': 'presente'},
    {'id': '2', 'name': 'María García', 'status': 'presente'},
    {'id': '3', 'name': 'Carlos López', 'status': 'ausente'},
  ];

  DateTime _selectedDate = DateTime.now();

  void _updateAttendance(String studentId, String status) {
    setState(() {
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
      body: Column(
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
                          _updateAttendance(student['id'], newValue);
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
      ),
    );
  }
}