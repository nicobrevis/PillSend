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

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Bloquear el retroceso si el usuario ha iniciado sesión
        return false;
      },
      child: MaterialApp(
        home: MainMenuScreen(),
        debugShowCheckedModeBanner: false,
      ),
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
          MaterialPageRoute(
              builder: (context) => const EntregaAlimentosScreen()),
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
        backgroundColor: Color.fromARGB(255, 30, 162, 236),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuButton(context, Icons.medication, const Color(0xFFDBA8A8),
                0, 'Medicamentos', 0.8),
            _buildMenuButton(context, Icons.account_circle,
                const Color(0xFFEFC678), 1, 'Perfil', 0.8),
            _buildMenuButton(context, Icons.local_dining,
                const Color(0xFF7DD094), 2, 'Alimentos', 0.8),
            _buildMenuButton(context, Icons.calendar_today,
                const Color(0xFF40CED7), 3, 'Controles', 0.8),
            _buildMenuButton(context, Icons.settings, const Color(0xFFD1E6E9),
                4, 'Configuración', 0.8,
                doubleWidth: true),
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
    double opacity, {
    bool doubleWidth = false,
  }) {
    return Material(
      elevation: 10, // Altura de la sombra
      borderRadius: BorderRadius.circular(10), // Borde redondeado
      child: InkWell(
        onTap: () {
          _onButtonPressed(context, index);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: doubleWidth ? double.infinity : 120,
          height: 120,
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 100, color: Colors.white.withOpacity(opacity)),
              Text(
                texto,
                textAlign: TextAlign.center, // Centra el texto
                style: const TextStyle(
                  color: const Color(0xFF3F87A5),
                  fontSize: 24, // Tamaño de la letra
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
