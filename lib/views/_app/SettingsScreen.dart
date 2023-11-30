import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        backgroundColor: Color.fromARGB(255, 30, 162, 236),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Cerrar sesion'),
            leading: Icon(Icons.person),
            onTap: () {
              // Acción para abrir la configuración de perfil
              // Puedes navegar a otra pantalla o ejecutar una acción aquí.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Cerrar sesión'),
                    content: Text('¿Estas seguro que deseas cerrar sesión?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          await GoogleSignIn().signOut();
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(
                            context,
                          );
                        },
                        child: Text('Seguir aquí'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await GoogleSignIn().signOut();
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        child: Text('Cerrar sesión'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
