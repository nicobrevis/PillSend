import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Perfil'),
            leading: Icon(Icons.person),
            onTap: () {
              // Acción para abrir la configuración de perfil
              // Puedes navegar a otra pantalla o ejecutar una acción aquí.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Configuración de Perfil'),
                    content: Text('Personaliza tu perfil aquí.'),
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
