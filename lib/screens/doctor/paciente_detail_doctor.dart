import 'package:flutter/material.dart';
import 'package:pillsend/screens/doctor/add_medic.dart';

import '../Medicamento.dart';
import '../firestore.dart';
import 'detail_medic_doctor.dart';

class ExpansionTileApp extends StatelessWidget {
  const ExpansionTileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PillSend'),
      ),
      body: const SingleChildScrollView(
        // Agregado SingleChildScrollView
        child: ExpansionTileExample(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const AddMedicamentoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  const ExpansionTileExample({Key? key}) : super(key: key);

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  Map<String, dynamic>? selectedMedicamento;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Medicamentos",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getMedicamento(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((medicamento) {
                    return ExpansionTile(
                      title: Text(medicamento['nombre']),
                      subtitle:
                          Text('Cada ' + medicamento['frecuencia'] + ' horas'),
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                child: const Text('Detalles'),
                                onPressed: () {
                                  setState(() {
                                    selectedMedicamento = medicamento;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => TableList(
                                        medicamento: selectedMedicamento,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return const Text('Error al cargar los medicamentos');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            child: const Text('Buscar medicamento'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicamentosList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
