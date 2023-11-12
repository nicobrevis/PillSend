import 'package:flutter/material.dart';
import 'package:pillsend/views/_app/AsmaHistoryScreen.dart';
import 'package:pillsend/views/_app/DentalHistoryScreen.dart';

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
          buildControlItem2('Historial dental', 'Ver historial dental', () {
            // Navegar a la página de historial de asma al hacer clic en el ítem
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DentalHistoryScreen()),
            );
          }),


          buildSectionTitle('Controles de Asma'),
          buildControlItem('Próximo control de asma', '25 de septiembre, 2023'),
          buildControlItem2('Historial de asma', 'Ver historial de asma', () {
            // Navegar a la página de historial de asma al hacer clic en el ítem
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AsmaHistoryScreen()),
            );
          }),
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

  Widget buildControlItem2(String title, String subtitle, VoidCallback? onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
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


