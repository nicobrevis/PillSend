import 'package:flutter/material.dart';


class HealthControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Futuros Controles de Salud'),
      ),
      body: ListView(
        children: <Widget>[
          buildSectionTitle('Controles Dentales'),
          buildControlItem('Próximo control dental', '12 de agosto, 2023'),
          buildControlItem('Historial dental', 'Ver historial dental'),

          buildSectionTitle('Controles de Asma'),
          buildControlItem('Próximo control de asma', '25 de septiembre, 2023'),
          buildControlItem('Historial de asma', 'Ver historial de asma'),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      color: Colors.blue[100],
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildControlItem(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        // Acción para mostrar detalles del control de salud
        // Puedes navegar a otra pantalla o ejecutar una acción aquí.
      },
    );
  }
}
