import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool _isButtonDisabled = true;

class CalendarDialog extends StatefulWidget {
  final Function(Timestamp) onReserve;

  CalendarDialog({required this.onReserve});

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  void _onCalendarFormatChanged(CalendarFormat format) {
    setState(() {});
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _checkButtonState();
      });
    }
  }

  void _checkButtonState() {
    setState(() {
      _isButtonDisabled = _selectedDate == null || _selectedTime == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar fecha y hora'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 300,
          height: 550,
          child: Column(
            children: [
              TableCalendar(
                locale: 'es_ES',
                firstDay: DateTime.now(),
                lastDay: DateTime(2030),
                focusedDay: _selectedDate,
                calendarFormat: CalendarFormat.month,
                onFormatChanged: _onCalendarFormatChanged,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: (date, focusedDate) {
                  setState(() {
                    _selectedDate = date;
                    _checkButtonState();
                  });
                },
                selectedDayPredicate: (date) {
                  return isSameDay(_selectedDate, date);
                },
                calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date, events) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  weekendStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                onPressed: () => _selectTime(context),
                child: const Text('Seleccionar hora'),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isButtonDisabled
              ? null
              : () async {
                  if (_selectedDate != null && _selectedTime != null) {
                    // Obtén el UID del usuario actualmente autenticado
                    String userUid = FirebaseAuth.instance.currentUser!.uid;

                    // Crea una referencia al documento en la colección "reservas" con el UID del usuario
                    DocumentReference reservationRef =
                        FirebaseFirestore.instance.collection('reservas').doc(userUid);

                    // Guarda la fecha y hora en el documento como un objeto Timestamp
                    Timestamp dateTimeStamp = Timestamp.fromDate(
                        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
                            _selectedTime!.hour, _selectedTime!.minute));

                    await reservationRef.set({
                      'fecha': dateTimeStamp,
                    });

                    // Llama a la función de devolución de llamada para pasar datos a la pantalla principal
                    widget.onReserve(dateTimeStamp);
                    Navigator.of(context).pop();
                  }
                },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
          ),
          child: const Text('Reservar'),
          
        ),
      ],
    );
  }
}