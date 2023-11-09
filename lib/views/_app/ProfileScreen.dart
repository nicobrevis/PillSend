import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  Future<String?> _getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userUid');
  }

  Future<Map<String, dynamic>?> _getUserData(String userUid) async {
    try {
      // Obtén una instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Realiza una consulta para obtener los datos del usuario
      DocumentSnapshot userSnapshot =
          await firestore.collection('usuarios').doc(userUid).get();

      if (userSnapshot.exists) {
        // El documento del usuario existe, devuelve sus datos
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        // El documento del usuario no existe
        return null;
      }
    } catch (e) {
      // Maneja los errores según sea necesario
      print('Error al obtener datos de usuario: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Paciente'),
        backgroundColor: Color(0xFF84D4A4), // Color verde pastel
      ),
      body: FutureBuilder(
        future: _getUserUid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            String? userUid = snapshot.data as String?;
            return FutureBuilder(
              future: _getUserData(userUid!),
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (userDataSnapshot.hasError) {
                  return Text('Error: ${userDataSnapshot.error}');
                } else if (userDataSnapshot.hasData) {
                  // Aquí puedes construir la interfaz de usuario utilizando los datos del usuario
                  Map<String, dynamic>? userData =
                      userDataSnapshot.data as Map<String, dynamic>?;
                  return buildUserProfile(userData);
                } else {
                  return Text('Usuario no encontrado');
                }
              },
            );
          } else {
            return Text('Usuario no autenticado');
          }
        },
      ),
    );
  }

  // Esta función construye la interfaz de usuario utilizando los datos del usuario
  Widget buildUserProfile(Map<String, dynamic>? userData) {
    // Comprueba si userData es nulo (usuario no encontrado) y actúa en consecuencia
    if (userData == null) {
      return Text('Usuario no encontrado');
    }

    // Construye la interfaz de usuario utilizando los datos del usuario
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Foto del perfil (sustituye con la URL de la imagen)
          Container(
            width: 150,
            height: 150,
            //child: Image.network(userData['imagenPerfil']),
          ),
          SizedBox(height: 20),
          // Nombre del paciente
          Text(
            userData['nombre'],
            style: TextStyle(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // Información del perfil
          InfoTile(
              icon: Icons.cake,
              text: 'Fecha de Nacimiento: ${userData['fechaNacimiento']}'),
          InfoTile(icon: Icons.local_hospital, text: 'Previsión: ${userData['prevision']}'),
          InfoTile(icon: Icons.star, text: 'Edad: ${userData['edad']} años'),
          InfoTile(icon: Icons.opacity, text: 'Grupo Sanguíneo: ${userData['grupoSanguineo']}'),
          InfoTile(
              icon: Icons.local_pharmacy,
              text: 'Enfermedad Crónica: ${userData['EnfermedadCronica']}'),
          InfoTile(
              icon: Icons.local_hospital,
              text: 'Establecimiento de Salud: ${userData['establecimiento']}'),
          InfoTile(icon: Icons.location_on, text: 'Comuna: ${userData['comuna']}'),
        ],
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
