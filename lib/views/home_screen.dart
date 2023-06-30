import 'package:pillsend/utils/exports.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('PillSend'),
            automaticallyImplyLeading: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    customText(
                        txt: "¡Bienvenido a PillSend!",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    customText(
                        txt: "Inicia sesión o regístrate.",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset("images/temporal_logo.png", height: 150),
                    const SizedBox(
                      height: 40,
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
                      height: 40,
                    ),
                    InkWell(
                      child: SignUpContainer(st: "Registrarte"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                      },
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
