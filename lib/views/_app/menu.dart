import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EntregaAlimentosScreen.dart';
import 'EntregaMedicamentosScreen.dart';
import 'HealthControlScreen.dart';
import 'ProfileScreen.dart';
import 'SettingsScreen.dart';

readFromSharedPreferences(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString(key);
  print(value);
  
}






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

  @override
  void initState() {
    super.initState();
    readFromSharedPreferences('userUid');
    print('User UID not found');
  }

  void _onButtonPressed(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EntregaMedicamentosScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EntregaAlimentosScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthControlScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
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
            _buildMenuButton(context, Icons.medication, Colors.blue, 0,'Retiro de medicamentos'),
            _buildMenuButton(
                context, Icons.health_and_safety_rounded, Colors.green, 1,'Ficha médica'),
            _buildMenuButton(context, Icons.apple, Colors.orange, 2,'Retiro de alimentos'),
            _buildMenuButton(context, Icons.food_bank, Colors.purple, 3,'Próximos controles'),
            _buildMenuButton(context, Icons.settings, Colors.red, 4,'configuración'),
            _buildMenuButton(context, Icons.info, Colors.teal, 5,'Información'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
  BuildContext context,
  IconData icon,
  Color color,
  int index,
  String texto,
) {
  return Material(
    elevation: 10, // Altura de la sombra
    borderRadius: BorderRadius.circular(10), // Borde redondeado
    child: InkWell(
      onTap: () {
        _onButtonPressed(context, index);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: Colors.white),
            Text(
              texto,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20, // Tamaño de la letra
                fontWeight: FontWeight.bold, // Peso de la letra (opcional)
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
