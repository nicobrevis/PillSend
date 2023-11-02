import 'package:pillsend/utils/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static Future<User?> registerUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La contraseña es muy débil')));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ya existe una cuenta con ese correo electrónico')));
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('El correo electrónico no es válido')));
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
    TextEditingController _passwordControllerConfirm = TextEditingController();
    TextEditingController _rutController = TextEditingController();
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
                        txt: "Registrarse",
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
                            hintText: 'ejemplo@gmail.com'),
                      ),
                    ),
                    //CustomTextField(Lone: "Password", Htwo: "Password"),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _passwordControllerConfirm,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirmar contraseña',
                            hintText: 'Vuelve a ingresar contraseña'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _rutController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Rut',
                            hintText: 'Ingresa tu RUT'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                                context: context);
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
                            one: "¿Ya tienes cuenta? ", two: "Iniciar sesión."),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
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
