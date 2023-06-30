import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pillsend/views/home_screen.dart';
import '../../utils/code_refector.dart';
import '../firestore.dart';
import 'add_paciente.dart';
import 'paciente_detail_doctor.dart';

class PacienteList extends StatefulWidget {
  const PacienteList({Key? key}) : super(key: key);

  @override
  _PacienteListState createState() => _PacienteListState();
}

class _PacienteListState extends State<PacienteList> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            customText(
                txt: "Lista de pacientes",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 30),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getPaciente(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Map<String, dynamic>> pacienteList =
                      snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: pacienteList.length,
                      itemBuilder: (context, index) {
                        final paciente = pacienteList[index];
                        final String nombre = paciente['nombre'] ?? '';
                        final String edad = paciente['edad'] ?? '';
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.account_circle, size: 40),
                          ),
                          title: Text(nombre),
                          subtitle: Text('$edad años'),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ExpansionTileApp(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error al cargar los pacientes');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const AddPacienteDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
