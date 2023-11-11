import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'CalendarDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu.dart';

class EntregaMedicamentosScreen extends StatefulWidget {
  const EntregaMedicamentosScreen({Key? key}) : super(key: key);

  @override
  _EntregaMedicamentosScreenState createState() =>
      _EntregaMedicamentosScreenState();
}

class _EntregaMedicamentosScreenState extends State<EntregaMedicamentosScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String fechaReserva = ''; // Variable para almacenar la fecha de reserva

  @override
  void initState() {
    super.initState();
    _loadReservationDate(); // Carga la fecha de reserva al iniciar la pantalla
  }

  void _onCalendarFormatChanged(CalendarFormat format) {
    setState(() {});
  }

  // Esta función se llama cuando se presiona el botón 'Reservar' en CalendarDialog
  void _handleReservation(Timestamp dateTimeStamp) async {
    // Actualiza la fecha y hora en el estado y en Firestore
    setState(() {
      _selectedDate = dateTimeStamp.toDate();
      _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
      fechaReserva =
          'Fecha de reserva de medicamentos: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedTime!.hour}:${_selectedTime!.minute}';
    });

    // Muestra la alerta (SnackBar) después de reservar la hora
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.green), // Icono de check
            SizedBox(width: 8), // Espaciado entre el icono y el texto
            Text('Hora reservada con éxito'),
          ],
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }

  // Cargar la fecha de reserva desde Firestore
  _loadReservationDate() async {
    // Obtén el UID del usuario actualmente autenticado
    String userUid = FirebaseAuth.instance.currentUser!.uid;

    // Crea una referencia al documento en la colección "reservas" con el UID del usuario
    DocumentReference reservationRef =
        FirebaseFirestore.instance.collection('reservas').doc(userUid);

    // Obtiene los datos del documento
    DocumentSnapshot reservationSnapshot = await reservationRef.get();

    // Verifica si el documento existe
    if (reservationSnapshot.exists) {
      Timestamp dateTimeStamp =
          (reservationSnapshot.data() as dynamic)['fecha'];
      _handleReservation(dateTimeStamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Bloquear el retroceso si el usuario ha iniciado sesión
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PillSend'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Entrega de Medicamentos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Fecha de entrega: 01/01/2023',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Fecha de próxima entrega: 02/01/2023',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(),
                      // Fecha de reserva
                      if (fechaReserva.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            fechaReserva,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CalendarDialog(
                                onReserve: _handleReservation,
                              ),
                            );
                          },
                          child: const Text('Reservar hora'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
