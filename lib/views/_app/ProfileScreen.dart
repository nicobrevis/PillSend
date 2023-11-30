import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  Future<String?> _getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userUid');
  }

  Future<Map<String, dynamic>?> _getUserData(String userUid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userSnapshot =
          await firestore.collection('usuarios').doc(userUid).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener datos de usuario: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Paciente'),
        backgroundColor: Color.fromARGB(255, 30, 162, 236),
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
                if (userDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (userDataSnapshot.hasError) {
                  return Text('Error: ${userDataSnapshot.error}');
                } else if (userDataSnapshot.hasData) {
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

  Widget buildUserProfile(Map<String, dynamic>? userData) {
    if (userData == null) {
      return Text('Usuario no encontrado');
    }

    // Formatea la fecha de nacimiento
    DateTime fechaNacimiento =
        (userData['fechaNacimiento'] as Timestamp).toDate();
    String formattedFechaNacimiento =
        DateFormat('dd/MM/yyyy').format(fechaNacimiento);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            userData['nombre'],
            style: TextStyle(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          InfoTile(
            icon: Icons.cake,
            text: 'Fecha de Nacimiento: $formattedFechaNacimiento',
          ),
          InfoTile(
            icon: Icons.star,
            text: 'Edad: ${userData['edad']} años',
          ),
          InfoTile(
            icon: Icons.location_city,
            text: 'Comuna: ${userData['comuna']}',
          ),
          InfoTile(
            icon: Icons.local_hospital,
            text: 'Establecimiento de Salud: ${userData['establecimiento']}',
          ),
          InfoTile(
            icon: Icons.local_hospital,
            text: 'Enfermedad Crónica: ${userData['enfermedadCronica']}',
          ),
          InfoTile(
            icon: Icons.opacity,
            text: 'Grupo Sanguíneo: ${userData['grupoSanguineo']}',
          ),
          InfoTile(
            icon: Icons.local_hospital,
            text: 'Previsión: ${userData['prevision']}',
          ),
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
      leading: Icon(icon, color: Color(0xFF84D4A4)),
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
