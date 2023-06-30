import 'package:flutter/material.dart';
import 'package:pillsend/utils/exports.dart';
import '../firestore.dart';
import 'paciente_detail_doctor.dart';

class AddMedicamentoDialog extends StatefulWidget {
  const AddMedicamentoDialog({Key? key}) : super(key: key);

  @override
  _AddMedicamentoDialogState createState() => _AddMedicamentoDialogState();
}

class _AddMedicamentoDialogState extends State<AddMedicamentoDialog> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _frecuenciaController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _finalController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _dosisController.dispose();
    _frecuenciaController.dispose();
    _duracionController.dispose();
    _inicioController.dispose();
    _finalController.dispose();
    super.dispose();
  }

  Future<void> showDialogMessage() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Medicamento guardado exitosamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ExpansionTileApp(),
                ),
              );
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  bool validateFields() {
    if (_nombreController.text.isEmpty ||
        _dosisController.text.isEmpty ||
        _frecuenciaController.text.isEmpty ||
        _duracionController.text.isEmpty ||
        _inicioController.text.isEmpty ||
        _finalController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Medicamento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _dosisController,
              decoration: const InputDecoration(labelText: 'Dosis'),
            ),
            TextField(
              controller: _frecuenciaController,
              decoration:
                  const InputDecoration(labelText: 'Frecuencia (horas)'),
            ),
            TextField(
              controller: _duracionController,
              decoration: const InputDecoration(labelText: 'Duración'),
            ),
            TextField(
              controller: _inicioController,
              decoration: const InputDecoration(labelText: 'Inicio'),
            ),
            TextField(
              controller: _finalController,
              decoration: const InputDecoration(labelText: 'Final'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            if (validateFields()) {
              final String nombre = _nombreController.text;
              final String dosis = _dosisController.text;
              final String frecuencia = _frecuenciaController.text;
              final String duracion = _duracionController.text;
              final String inicio = _inicioController.text;
              final String fin = _finalController.text;

              await addMedicamento(
                nombre,
                dosis,
                frecuencia,
                duracion,
                inicio,
                fin,
              );
              Navigator.of(context).pop();
              showDialogMessage();
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: const Text(
                      'Por favor, rellena todos los campos antes de guardar.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
