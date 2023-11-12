import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importa la clase DateFormat
import 'package:pillsend/screens/firestore.dart';

class DentalHistoryScreen extends StatelessWidget {
  const DentalHistoryScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Dental'),
      ),
      body: FutureBuilder(
        future: fetchDentalHistory(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 20), // Tamaño de fuente más grande
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text(
              'No hay datos en el historial de asma.',
              style: TextStyle(fontSize: 20), // Tamaño de fuente más grande
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> controlDental = snapshot.data![index];
                Timestamp fecha = controlDental['fecha'] as Timestamp;
                String info = controlDental['info'] as String;

                // Formatea la fecha y la hora con los formatos deseados
                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(fecha.toDate());
                String formattedTime = DateFormat('HH:mm').format(fecha.toDate());

                return ListTile(
                  title: Text(
                    'Fecha: $formattedDate',
                    style: const TextStyle(fontSize: 20), // Tamaño de fuente más grande
                  ),
                  subtitle: Text(
                    'Hora: $formattedTime\nInformación: $info',
                    style: const TextStyle(
                      fontSize: 18, // Tamaño de fuente más grande
                      fontWeight: FontWeight.bold, // Texto en negrita
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
