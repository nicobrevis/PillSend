import 'package:flutter/material.dart';

class Medicamento {
  final String nombre;
  final String dosis;

  Medicamento({required this.nombre, required this.dosis});
}

class MedicamentosRecetadosScreen extends StatelessWidget {
  final List<Medicamento> medicamentos = [
    Medicamento(nombre: 'Aspirina', dosis: '1 tableta cada 6 horas'),
    Medicamento(nombre: 'Paracetamol', dosis: '2 tabletas cada 8 horas'),
    Medicamento(nombre: 'Amoxicilina', dosis: '1 cápsula cada 12 horas'),
    // Agrega más medicamentos según sea necesario
  ];

  MedicamentosRecetadosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos Recetados'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 30, 162, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Lista de Medicamentos Recetados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: medicamentos.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(medicamentos[index].nombre),
                      subtitle: Text('Dosis: ${medicamentos[index].dosis}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
