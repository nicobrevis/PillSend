import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  const CalendarDialog({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.onCancel,
    required this.onReserve,
  }) : super(key: key);

  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final VoidCallback onCancel;
  final VoidCallback onReserve;

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onCalendarFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
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
                focusedDay: widget.selectedDate,
                calendarFormat: _calendarFormat,
                onFormatChanged: _onCalendarFormatChanged,
                onDaySelected: (date, focusedDate) {
                  widget.onDateSelected(date);
                },
                selectedDayPredicate: (date) {
                  return isSameDay(widget.selectedDate, date);
                },
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
                onPressed: () => widget.onTimeSelected(widget.selectedTime),
                child: const Text('Seleccionar hora'),
              ),
              const SizedBox(height: 16),
              Text(
                'Fecha seleccionada: ${widget.selectedDate.toString()}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Hora seleccionada: ${widget.selectedTime.format(context)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: widget.onReserve,
          child: const Text('Reservar'),
        ),
      ],
    );
  }
}
