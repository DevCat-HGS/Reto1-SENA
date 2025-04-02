import 'package:flutter/material.dart';
import 'attendance_page.dart';
import 'evaluation_page.dart';
import 'grades_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String userRole;
  
  const HomePage({super.key, required this.userRole});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SENA - Inicio'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userRole: widget.userRole),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rol: ${widget.userRole}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Nombre del Usuario',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Text(
                      'correo@ejemplo.com',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Asistencia'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendancePage(userRole: widget.userRole),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Evaluaciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EvaluationPage(userRole: widget.userRole),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Calificaciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GradesPage(userRole: widget.userRole),
                  ),
                );
              },
            ),
            if (widget.userRole == 'instructor') ...[              
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Gestionar Aprendices'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Próximamente: Gestión de aprendices'),
                    ),
                  );
                },
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.userRole == 'instructor') ...[
                const Text(
                  'Mis Cursos a Cargo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.school),
                          ),
                          title: Text('Curso ${index + 1}'),
                          subtitle: Text('Código: C00${index + 1} - 20 estudiantes'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendancePage(userRole: widget.userRole),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Asistencias Recientes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.calendar_today),
                          ),
                          title: Text('Registro de Asistencia - Curso ${index + 1}'),
                          subtitle: Text('${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().month}/2024'),
                          trailing: Text('${15 + index} estudiantes'),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[  // Vista para aprendices
                const Text(
                  'Mis Materias Inscritas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.book),
                          ),
                          title: Text('Materia ${index + 1}'),
                          subtitle: Text('Instructor: Profesor ${index + 1}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Nota: ${4.0 + (index * 0.2)}'),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GradesPage(userRole: widget.userRole),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Próximas Evaluaciones',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.assignment),
                          ),
                          title: Text('Evaluación ${index + 1}'),
                          subtitle: Text('Fecha: ${DateTime.now().add(Duration(days: index + 1)).day}/${DateTime.now().month}/2024'),
                          trailing: const Text('Pendiente'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: widget.userRole == 'instructor'
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Próximamente: Crear nuevo curso'),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}