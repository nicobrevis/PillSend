import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pillsend/screens/paciente/detail_medic_paciente.dart';
import '../Medicamento.dart';
import '../firestore.dart';

class ExpansionTileApp extends StatelessWidget {
  const ExpansionTileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PillSend'),
      ),
      body: SingleChildScrollView(
        // Agregado: Envuelve el ExpansionTileExample con SingleChildScrollView
        child: const ExpansionTileExample(),
      ),
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
                    DateTime now = DateTime.now();
                    DateTime endTime = now.add(Duration(
                      hours: int.parse(medicamento['frecuencia']),
                    ));

                    CountdownTimer countdownTimer = CountdownTimer(
                      endTime: endTime.millisecondsSinceEpoch,
                      widgetBuilder: (_, CurrentRemainingTime? time) {
                        if (time == null) {
                          return const SizedBox();
                        }
                        return Text(
                          'La alarma sonará en ${time.hours}:${time.min}:${time.sec}',
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    );

                    return ExpansionTile(
                      title: Text(medicamento['nombre']),
                      subtitle:
                          Text('Cada ' + medicamento['frecuencia'] + ' horas'),
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              countdownTimer,
                              ElevatedButton(
                                child: const Text('Detalles'),
                                onPressed: () {
                                  setState(() {
                                    selectedMedicamento = medicamento;
                                  });
                                  Navigator.push(
                                    context,
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
