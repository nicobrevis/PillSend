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

  void _deleteReservation() async {
    try {
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      // Crea una referencia al documento en la colección 'reservas' con el userUid
      DocumentReference reservationRef =
          FirebaseFirestore.instance.collection('reservas').doc(userUid);

      // Elimina el documento
      await reservationRef.delete();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EntregaMedicamentosScreen(),
        ),
      );
      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reserva eliminada con éxito'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Muestra un mensaje de error si algo sale mal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la reserva'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

    // Retraso antes de mostrar la alerta
    await Future.delayed(Duration(milliseconds: 500));
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
          backgroundColor: Color.fromARGB(255, 30, 162, 236),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Box con sombra y fondo azul para el título
              _buildBlueBox('Entrega de Medicamentos', 24, FontWeight.bold),
              const SizedBox(height: 16),
              // Expanded para ocupar el espacio restante
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateBox('Fecha de entrega: 01/01/2023'),
                      _buildDateBox('Fecha de próxima entrega: 02/01/2023'),
                      // Fecha de reserva
                      if (fechaReserva.isNotEmpty) _buildDateBox(fechaReserva),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            ElevatedButton(
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
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                onPrimary: Colors.white,
                              ),
                              onPressed: () {
                                // Lógica para eliminar la hora

                                _showDeleteConfirmationDialog();
                              },
                              child: const Text('Eliminar hora'),
                            ),
                          ],
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

  // Método para construir las cajas de fecha
  Widget _buildDateBox(String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  // Método para construir cajas con sombra y fondo azul
  Widget _buildBlueBox(String text, double fontSize, FontWeight fontWeight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
        ),
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación de eliminación
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar hora'),
        content: const Text('¿Estás seguro de que deseas eliminar la hora?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deleteReservation();
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
