import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class EntregaMedicamentosScreen extends StatefulWidget {
  const EntregaMedicamentosScreen({Key? key}) : super(key: key);

  @override
  _EntregaMedicamentosScreenState createState() =>
      _EntregaMedicamentosScreenState();
}

class _EntregaMedicamentosScreenState extends State<EntregaMedicamentosScreen> {
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
      });
    }
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  onPressed: () {
                    // Lógica de reserva de fecha y hora
                    print('Fecha seleccionada: ${_selectedDate.toString()}');
                    if (_selectedTime != null) {
                      print(
                          'Hora seleccionada: ${_selectedTime!.format(context)}');
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: const Text('Reservar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String fechaReserva = '';
    if (_selectedTime != null) {
      fechaReserva =
          'Fecha de reserva de medicamentos: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedTime!.hour}:${_selectedTime!.minute}';
    }

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.green,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PillSend'),
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
                      if (_selectedTime != null)
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
                            _showCalendarDialog(context);
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
