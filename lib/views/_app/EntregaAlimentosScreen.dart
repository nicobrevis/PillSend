import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'CalendarDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntregaAlimentosScreen extends StatefulWidget {
  const EntregaAlimentosScreen({Key? key}) : super(key: key);

  @override
  _EntregaAlimentosScreenState createState() => _EntregaAlimentosScreenState();
}

class _EntregaAlimentosScreenState extends State<EntregaAlimentosScreen> {
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
  void _handleReservation(DateTime selectedDate, TimeOfDay? selectedTime) {
    setState(() {
      _selectedDate = selectedDate;
      _selectedTime = selectedTime;
      fechaReserva =
          'Fecha de reserva de alimentos: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedTime!.hour}:${_selectedTime!.minute}';
      _saveReservationDateAlimentos(); // Guarda la fecha de reserva
    });
  }

  // Guardar la fecha de reserva en SharedPreferences
  _saveReservationDateAlimentos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('reservationDate', fechaReserva);
  }

  // Cargar la fecha de reserva desde SharedPreferences
  _loadReservationDate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedReservationDate = prefs.getString('reservationDate');
    if (savedReservationDate != null) {
      setState(() {
        fechaReserva = savedReservationDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PillSend'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 224, 230, 153),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Entrega de alimentos',
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
                    /*Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                CalendarDialog(onReserve: _handleReservation),
                          );
                        },
                        child: const Text('Reservar hora'),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
