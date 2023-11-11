// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pillsend/utils/exports.dart';
import 'package:pillsend/views/welcome_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/firestore.dart';
import '_app/menu.dart';

class WelcomeScreen_google extends StatefulWidget {
  const WelcomeScreen_google({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen_google> {
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
                  txt: "Ingresa tu RUT sin puntos y con guión.",
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
                          registerUsingEmailPassword(
                            email: FirebaseAuth.instance.currentUser!.email!,
                            password: '123456',
                            rut: _rutController.text,
                            context: context,
                          );
                        },
                        child: const Text('Verificar'),
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

  static Future<bool> checkIfRutExists(String rut) async {
    try {
      final QuerySnapshot rutSnapshot = await FirebaseFirestore.instance
          .collection('rutRegistro')
          .where('rut', isEqualTo: rut)
          .get();

      return rutSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar si el RUT existe: $e');
      return false;
    }
  }

  Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
    required String rut,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      await prefs.setString('userUid', user.uid);

      // Verificar si el 'rut' existe en la colección 'rutRegistro'
      bool rutExists = await checkIfRutExists(rut);

      if (rutExists) {
        // Si existe, asociar datos a usuario
        final userUid = await prefs.getString('userUid') ?? '';
        await asociarDatosAUsuario(email, rut, userUid);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreenNoRut()),
        );
        print('XDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
      }
    }

    return user;
  }

  Future<void> asociarDatosAUsuario(
      String email, String rut, String userUid) async {
    try {
      final QuerySnapshot rutSnapshot = await FirebaseFirestore.instance
          .collection('rutRegistro')
          .where('rut', isEqualTo: rut)
          .get();

      if (rutSnapshot.docs.isNotEmpty) {
        final DocumentSnapshot rutDocument = rutSnapshot.docs.first;
        final userData = rutDocument.data() as Map<String, dynamic>;

        // Extraer los datos del documento 'rutRegistro'
        final enfermedadCronica = userData['enfermedadCronica'];
        final comuna = userData['comuna'];
        final edad = userData['edad'];
        final establecimiento = userData['establecimiento'];
        final fechaNacimiento = userData['fechaNacimiento'];
        final grupoSanguineo = userData['grupoSanguineo'];
        final nombre = userData['nombre'];
        final prevision = userData['prevision'];

        // Guardar estos datos en la colección 'usuarios' con el nombre de documento 'userUid'
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userUid)
            .set({
          'enfermedadCronica': enfermedadCronica,
          'comuna': comuna,
          'edad': edad,
          'establecimiento': establecimiento,
          'fechaNacimiento': fechaNacimiento,
          'grupoSanguineo': grupoSanguineo,
          'nombre': nombre,
          'prevision': prevision,
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
        // Realiza las acciones necesarias con estos datos
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreenNoRut(),
        ),
      );
      print('Error al asociar datos al usuario: $e');
    }
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
      print(_rutController.text);
      print(FirebaseAuth.instance.currentUser!.email!);
      print(FirebaseAuth.instance.currentUser!.uid);
      await
          // Redireccionar a una página si el rut existe
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    } else {
      // Redireccionar a otra página si el rut no existe
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreenNoRut(),
        ),
      );
    }
  }
}
