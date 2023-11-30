// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pillsend/screens/firestore.dart';
import 'package:pillsend/utils/exports.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../welcome_Screen.dart';
import '../welcome_Screen_google.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
    required String rut,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
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
    } on FirebaseAuthException catch (e) {
      // Manejo de excepciones
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña es muy débil')),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ya existe una cuenta con ese correo electrónico'),
          ),
        );
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El correo electrónico no es válido')),
        );
      }
    }
    return user;
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

  static Future<void> asociarDatosAUsuario(
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

        // Realiza las acciones necesarias con estos datos
      }
    } catch (e) {
      print('Error al asociar datos al usuario: $e');
    }
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            WelcomeScreen_google(userCredential: userCredential),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordControllerConfirm = TextEditingController();
    TextEditingController _rutController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('PillSend'),
            backgroundColor: Color.fromARGB(255, 30, 162, 236)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    customText(
                      txt: "Registrarse",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    customText(
                      txt: "Ingresa con tus redes sociales",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          text: 'Google',
                          buttonType: SocialLoginButtonType.google,
                          onPressed: () {
                            signInWithGoogle();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    customText(
                      txt: "O ingresa con tu correo electrónico",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 0,
                        bottom: 0,
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Correo electrónico',
                          hintText: 'ejemplo@gmail.com',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: 0,
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contraseña',
                          hintText: 'Ingresa una contraseña segura',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: 0,
                      ),
                      child: TextField(
                        controller: _passwordControllerConfirm,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirmar contraseña',
                          hintText: 'Vuelve a ingresar contraseña',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: 0,
                      ),
                      child: TextField(
                        controller: _rutController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Rut',
                          hintText: 'Ingresa tu RUT',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: 0,
                      ),
                      child: InkWell(
                        child: SignUpContainer(st: "Registrarse"),
                        onTap: () async {
                          print(_emailController.text);
                          print(_passwordController.text);
                          print(_passwordControllerConfirm.text);
                          if (_passwordController.text ==
                                  _passwordControllerConfirm.text &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            registerUsingEmailPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                              rut: _rutController.text,
                              context: context,
                            );
                          } else if (_emailController.text.isEmpty) {
                            const snackBar = SnackBar(
                              content: Text('Ingresa un correo electrónico'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (_passwordController.text.isEmpty) {
                            const snackBar = SnackBar(
                              content: Text('Ingresa una contraseña'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Las contraseñas no coinciden'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      child: RichText(
                        text: RichTextSpan(
                          one: "¿Ya tienes cuenta? ",
                          two: "Iniciar sesión.",
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
