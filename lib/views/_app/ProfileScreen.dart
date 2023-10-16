import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: ProfileScreen(),
      debugShowCheckedModeBanner: false,
    ));

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Paciente'),
        backgroundColor: Color(0xFF84D4A4), // Color verde pastel
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Foto del perfil
            Container(
              width: 150,
              height: 150,
              child: const Image(image: AssetImage("images/Niconiconi.png")),
            ),
            SizedBox(height: 20),
            // Nombre del paciente
            Text(
              'Juan Pérez',
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Información del perfil
            InfoTile(icon: Icons.cake, text: 'Fecha de Nacimiento: 15/05/1980'),
            InfoTile(icon: Icons.local_hospital, text: 'Previsión: Fonasa'),
            InfoTile(icon: Icons.star, text: 'Edad: 43 años'),
            InfoTile(icon: Icons.opacity, text: 'Grupo Sanguíneo: A+'),
            InfoTile(
                icon: Icons.local_pharmacy,
                text: 'Enfermedad Crónica: Diabetes'),
            InfoTile(
                icon: Icons.local_hospital,
                text: 'Establecimiento de Salud: Hospital General'),
            InfoTile(icon: Icons.location_on, text: 'Comuna: Santiago'),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  InfoTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF84D4A4)), // Color verde pastel
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
