import 'package:flutter/material.dart';

class Notificacion {
  final String titulo;
  final String mensaje;

  Notificacion({required this.titulo, required this.mensaje});
}

class NotificacionesScreen extends StatelessWidget {
  final List<Notificacion> notificaciones = [
    Notificacion(
      titulo: 'Recordatorio de medicamento',
      mensaje: 'Recuerda tomar la Aspirina a las 8:00 PM',
    ),
    Notificacion(
      titulo: 'Cita médica',
      mensaje: 'Tu cita médica está programada para mañana a las 10:00 AM',
    ),
    Notificacion(
      titulo: 'Entrega de medicamentos',
      mensaje: 'La entrega de medicamentos está programada para el viernes',
    ),
    // Agrega más notificaciones según sea necesario
  ];

  NotificacionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 30, 162, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Lista de Notificaciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: notificaciones.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(notificaciones[index].titulo),
                      subtitle: Text(notificaciones[index].mensaje),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
