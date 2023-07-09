import 'package:flutter/material.dart';

import 'EntregaMedicamentos.dart';

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  void _onButtonPressed(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EntregaMedicamentosScreen()),
        );
        break;
      case 1:
        // Acción al presionar el botón 2
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Botón 2'),
              content: const Text('Acción del botón 2'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
        break;
      case 2:
        // Acción al presionar el botón 3
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Botón 3'),
              content: const Text('Acción del botón 3'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
        break;
      case 3:
        // Acción al presionar el botón 4
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Botón 4'),
              content: const Text('Acción del botón 4'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
        break;
      case 4:
        // Acción al presionar el botón 5
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Botón 5'),
              content: const Text('Acción del botón 5'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
        break;
      case 5:
        // Acción al presionar el botón 6
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Botón 6'),
              content: const Text('Acción del botón 6'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PillSend'),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuButton(context, Icons.medication, Colors.blue, 0),
            _buildMenuButton(
                context, Icons.health_and_safety_rounded, Colors.green, 1),
            _buildMenuButton(context, Icons.apple, Colors.orange, 2),
            _buildMenuButton(context, Icons.food_bank, Colors.purple, 3),
            _buildMenuButton(context, Icons.settings, Colors.red, 4),
            _buildMenuButton(context, Icons.info, Colors.teal, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, IconData icon, Color color, int index) {
    return ElevatedButton(
      onPressed: () {
        _onButtonPressed(context, index);
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.zero,
        minimumSize: const Size(120, 120),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          icon,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
