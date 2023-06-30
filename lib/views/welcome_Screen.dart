// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pillsend/utils/exports.dart';
import 'package:pillsend/screens/doctor/paciente_list_doctor.dart';
import 'package:pillsend/screens/paciente/doctor_list_paciente.dart';

import '../screens/firestore.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? inputText;
  TextEditingController _rutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('PillSend'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 44),
            child: Column(
              children: [
                const Image(image: AssetImage("images/img2.png")),
                const SizedBox(height: 48),
                customText(
                  txt: "¡Bienvenido a PillSend!",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                customText(
                  txt: "Ingresa tu RUT sin puntos ni guión.",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _rutController,
                          decoration: const InputDecoration(
                            labelText: 'RUT',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              inputText = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          _checkRut();
                        },
                        child: const Text('Ingresar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkRut() async {
    List<Map<String, dynamic>> adminRutList = await getAdminRut();

    bool rutExists = false;
    for (var rutData in adminRutList) {
      String rutFromDB = rutData['rut'];
      if (rutFromDB == _rutController.text) {
        rutExists = true;
        break;
      }
    }

    if (rutExists) {
      // Redireccionar a una página si el rut existe
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PacienteList(),
        ),
      );
    } else {
      // Redireccionar a otra página si el rut no existe
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DoctorList(),
        ),
      );
    }
  }
}
