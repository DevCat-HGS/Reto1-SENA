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
              child: Column(
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
                  SizedBox(height: 10),
                  Text(
                    'Nombre del Usuario',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'correo@ejemplo.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userRole == 'instructor' ? 'Mis Cursos' : 'Mis Clases',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // TODO: Reemplazar con datos reales
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Curso ${index + 1}'),
                      subtitle: const Text('Descripción del curso'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Próximamente: Detalles del curso'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Actividades Recientes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // TODO: Reemplazar con datos reales
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.notifications),
                    ),
                    title: Text('Actividad ${index + 1}'),
                    subtitle: const Text('Hace 2 horas'),
                  );
                },
              ),
            ),
          ],
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