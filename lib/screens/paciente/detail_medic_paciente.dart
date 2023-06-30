import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import '../firestore.dart';
import 'doctor_detail_paciente.dart';

class TableList extends StatefulWidget {
  final Map<String, dynamic>? medicamento;

  const TableList({Key? key, this.medicamento}) : super(key: key);

  @override
  _TableListState createState() => _TableListState();
}



class _TableListState extends State<TableList> {
  @override
  Widget build(BuildContext context) {
    final medicamento = widget.medicamento;
    var frecuencia = medicamento!['frecuencia'].toString() + ' horas';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('PillSend'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ExpansionTileApp(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicamento['nombre'] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                },
                children: [
                  _buildTableRow('Dosis:', medicamento['dosis'].toString()),
                  _buildTableRow('Frecuencia:', frecuencia),
                  _buildTableRow(
                      'Duración:', medicamento['duracion'].toString()),
                  _buildTableRow('Inicio:', medicamento['inicio'].toString()),
                  _buildTableRow('Final:', medicamento['final'].toString()),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Medicamentos Baratos:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getBarato(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<Map<String, dynamic>> baratoList =
                          snapshot.data!;
                      final List<Map<String, dynamic>> matchedMedicamentos = [];
                      final String medicamentoNombre = medicamento['nombre'];

                      for (final barato in baratoList) {
                        final String baratoNombre = barato['nombre'];
                        if (baratoNombre == medicamentoNombre) {
                          matchedMedicamentos.add(barato);
                        }
                      }

                      return Column(
                        children: matchedMedicamentos.map((medicamento) {
                          return ListTile(
                            title: Text(medicamento['farmacia'] ?? ''),
                            subtitle:
                                Text('Precio: ${medicamento['precio'] ?? ''}'),
                            onTap: () {
                              String? link = medicamento['link'];
                              if (link != null) {
                                _launchURL(link);
                              }
                            },
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                          'Error al cargar los medicamentos baratos');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    await FlutterWebBrowser.openWebPage(url: url);
  }
}
