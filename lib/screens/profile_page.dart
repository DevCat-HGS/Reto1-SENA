import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userRole;
  
  const ProfilePage({super.key, required this.userRole});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, dynamic> _userData = {
    'name': 'Usuario Demo',
    'email': 'usuario@demo.com',
    'role': 'instructor',
    'document': '1234567890',
  };

  final List<Map<String, dynamic>> _assignedCourses = [
    {
      'id': '1',
      'name': 'Desarrollo de Software',
      'code': 'DS001',
      'schedule': 'Lunes y Miércoles 8:00 AM - 12:00 PM',
    },
    {
      'id': '2',
      'name': 'Bases de Datos',
      'code': 'BD001',
      'schedule': 'Martes y Jueves 2:00 PM - 6:00 PM',
    },
  ];

  void _showEditProfileDialog() {
    String name = _userData['name'];
    String document = _userData['document'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ingrese su nombre completo',
              ),
              controller: TextEditingController(text: name),
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Documento',
                hintText: 'Ingrese su número de documento',
              ),
              controller: TextEditingController(text: document),
              onChanged: (value) => document = value,
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
              setState(() {
                _userData['name'] = name;
                _userData['document'] = document;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil actualizado correctamente'),
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userData['name'],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Correo: ${_userData['email']}'),
                    Text('Documento: ${_userData['document']}'),
                    Text('Rol: ${_userData['role']}'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _showEditProfileDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar Perfil'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Cursos Asignados',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _assignedCourses.length,
              itemBuilder: (context, index) {
                final course = _assignedCourses[index];
                return Card(
                  child: ListTile(
                    title: Text(course['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código: ${course['code']}'),
                        Text('Horario: ${course['schedule']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Próximamente: Detalles del curso'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}