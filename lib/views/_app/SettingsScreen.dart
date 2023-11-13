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
        backgroundColor: Color(0xFF3F87A5),
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
          ListTile(
            title: Text('Notificaciones'),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Acción para abrir la configuración de notificaciones
              // Puedes navegar a otra pantalla o ejecutar una acción aquí.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Configuración de Notificaciones'),
                    content: Text('Personaliza tus notificaciones aquí.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('Privacidad'),
            leading: Icon(Icons.privacy_tip),
            onTap: () {
              // Acción para abrir la configuración de privacidad
              // Puedes navegar a otra pantalla o ejecutar una acción aquí.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Configuración de Privacidad'),
                    content: Text('Administra tu privacidad aquí.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
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
