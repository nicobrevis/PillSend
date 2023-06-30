import 'package:flutter/material.dart';

import 'paciente_detail_doctor.dart';

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
                  2: FixedColumnWidth(80), // Width for the Edit button column
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
        TableCell(
          child: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
