import 'package:flutter/material.dart';
import 'package:pillsend/views/_app/AsmaHistoryScreen.dart';
import 'package:pillsend/views/_app/DentalHistoryScreen.dart';

class HealthControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Futuros Controles de Salud'),
        backgroundColor: Color.fromARGB(255, 30, 162, 236),
      ),
      body: ListView(
        children: <Widget>[
          buildSectionWithShadow('Controles Dentales'),
          buildControlItem('Próximo control dental', '12 de agosto, 2023'),
          buildHistoryButton('Historial dental', 'Ver historial dental', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DentalHistoryScreen()),
            );
          }),
          buildSectionWithShadow('Controles de Asma'),
          buildControlItem('Próximo control de asma', '25 de septiembre, 2023'),
          buildHistoryButton('Historial de asma', 'Ver historial de asma', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AsmaHistoryScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget buildSectionWithShadow(String title) {
    return Container(
      transform: Matrix4.translationValues(0, 20, 0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 207, 233, 255),
      ),
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
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

  Widget buildHistoryButton(
      String title, String subtitle, VoidCallback? onTap) {
    return Container(
      transform: Matrix4.translationValues(0, -16, 0),
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: Colors.indigo, // Color de fondo del botón
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildControlItem(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.all(8),
      color: Color.fromARGB(255, 207, 233, 255),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
