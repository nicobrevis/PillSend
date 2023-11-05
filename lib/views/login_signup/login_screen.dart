import 'package:pillsend/utils/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future<void> saveUserUidToSharedPreferences(String userUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userUid', userUid);
}

class _LoginScreenState extends State<LoginScreen> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;

      if (user != null) {
        // Guardar el UID del usuario en SharedPreferences
        await saveUserUidToSharedPreferences(user.uid);

        // Navegar a la pantalla de bienvenida u otra pantalla después de iniciar sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
    }
    return user;
}


  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('PillSend')),
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
                        txt: "Iniciar sesión",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    customText(
                        txt: "Ingresa con tus redes sociales",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
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
                        // const SizedBox(
                        //   width: 2,
                        // ),
                        // SocialLoginButton(
                        //   text: 'Facebook',
                        //   buttonType: SocialLoginButtonType.facebook,
                        //   onPressed: () {},
                        // )
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
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    //CustomTextField(Lone: "Email", Htwo: "Email"),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 0, bottom: 0),
                      //padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Correo electrónico',
                            hintText: 'Ejemplo@gmail.com'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Contraseña',
                            hintText: 'Ingresa una contraseña segura'),
                      ),
                    ),
                    //CustomTextField(Lone: "Password", Htwo: "Password"),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextButton(
                        onPressed: () {
                          //TODO FORGOT PASSWORD SCREEN GOES HERE
                        },
                        child: const Text(
                          "¿Has olvidado la contraseña?",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: InkWell(
                        child: SignUpContainer(st: "Iniciar sesión"),
                        onTap: () async {
                          User? user = await loginUsingEmailPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                          print(user);
                          if (user != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()));
                          }
                          if (user == null) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Correo electrónico o Contraseña incorrectos. Inténtalo de nuevo.')));
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
                            one: "¿No tienes cuenta? ",
                            two: "Crear cuenta nueva"),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                      },
                    ),
                    //Text("data"),
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
