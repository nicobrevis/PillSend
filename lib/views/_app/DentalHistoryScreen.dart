import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pillsend/screens/firestore.dart';

class DentalHistoryScreen extends StatelessWidget {
  const DentalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Dental'),
        backgroundColor: Color(0xFF3F87A5),
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
              style: const TextStyle(fontSize: 20),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text(
              'No hay datos en el historial dental.',
              style: TextStyle(fontSize: 20),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> controlDental = snapshot.data![index];
                Timestamp fecha = controlDental['fecha'] as Timestamp;
                String info = controlDental['info'] as String;

                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(fecha.toDate());
                String formattedTime = DateFormat('HH:mm').format(fecha.toDate());

                return Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha: $formattedDate',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hora: $formattedTime\nInformación: $info',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
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
