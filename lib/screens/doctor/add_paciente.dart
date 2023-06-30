import 'package:flutter/material.dart';
import 'package:pillsend/utils/exports.dart';
import '../firestore.dart';
import 'paciente_list_doctor.dart';

class AddPacienteDialog extends StatefulWidget {
  const AddPacienteDialog({Key? key}) : super(key: key);

  @override
  _AddPacienteDialogState createState() => _AddPacienteDialogState();
}

class _AddPacienteDialogState extends State<AddPacienteDialog> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  Future<void> showDialogMessage() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Paciente guardado exitosamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PacienteList(),
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
    if (_nombreController.text.isEmpty || _edadController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Paciente'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _edadController,
              decoration: const InputDecoration(labelText: 'Edad'),
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
              final String edad = _edadController.text;

              await addPaciente(
                nombre,
                edad,
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
