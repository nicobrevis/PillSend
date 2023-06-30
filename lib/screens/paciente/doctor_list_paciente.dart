import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:pillsend/screens/counter_screen.dart';
import 'package:pillsend/screens/paciente/doctor_detail_paciente.dart';

import '../../utils/code_refector.dart';
import '../../views/home_screen.dart';
//import 'package:pillsend/screens/xd.dart';

class DoctorList extends StatelessWidget {
  const DoctorList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PillSend'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30),
            customText(
                txt: "Lista de doctores",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 30),
            ListTile(
              leading: const CircleAvatar(
                  child: Icon(Icons.account_circle, size: 40)),
              title: const Text('Dr Ivan Galaz'),
              subtitle: const Text('Urologo'),
              trailing: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExpansionTileApp()),
                  );
                },
                child: const Icon(Icons.more_horiz),
              ),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const CircleAvatar(
                  child: Icon(Icons.account_circle, size: 40)),
              title: const Text('Dr Pablo Ortiz'),
              subtitle: const Text('Odontólogo'),
              trailing: FloatingActionButton(
                  child: const Icon(Icons.more_horiz), onPressed: () {}),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const CircleAvatar(
                  child: Icon(Icons.account_circle, size: 40)),
              title: const Text('Dr Jefte Ponce'),
              subtitle: const Text('Ginecólogo'),
              trailing: FloatingActionButton(
                  child: const Icon(Icons.more_horiz), onPressed: () {}),
            ),
            const Divider(height: 0),
          ],
        ),
      ),
    );
  }
}
