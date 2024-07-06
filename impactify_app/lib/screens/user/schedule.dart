// import 'dart:collection';
// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:impactify_app/theming/custom_themes.dart';
// import 'package:table_calendar/table_calendar.dart';

// class Schedule extends StatefulWidget {
//   const Schedule({super.key});

//   @override
//   State<Schedule> createState() => _ScheduleState();
// }

// class _ScheduleState extends State<Schedule> {
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   DateTime _focusedDay = DateTime.now();
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
//   late final ValueNotifier<List<Event>> _selectedEvents;

//   @override
//   void initState() {
//     super.initState();

//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
//   }

//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }

//   List<Event> _getEventsForDay(DateTime day) {
//     // Implementation example
//     return [Event('test')];
//     //kEvents[day] ?? [];
//   }

//   List<Event> _getEventsForRange(DateTime start, DateTime end) {
//     // Implementation example
//     final days = daysInRange(start, end);

//     return [
//       for (final d in days) ..._getEventsForDay(d),
//     ];
//   }

//   int getHashCode(DateTime key) {
//     return key.day * 1000000 + key.month * 10000 + key.year;
//   }

  

//   List<DateTime> daysInRange(DateTime first, DateTime last) {
//     final dayCount = last.difference(first).inDays + 1;
//     return List.generate(
//       dayCount,
//       (index) => DateTime.utc(first.year, first.month, first.day + index),
//     );
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null;
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });

//       _selectedEvents.value = _getEventsForDay(selectedDay);
//     }
//   }

//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = null;
//       _focusedDay = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });

//     if (start != null && end != null) {
//       _selectedEvents.value = _getEventsForRange(start, end);
//     } else if (start != null) {
//       _selectedEvents.value = _getEventsForDay(start);
//     } else if (end != null) {
//       _selectedEvents.value = _getEventsForDay(end);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(
//                 text: 'My ',
//                 style: GoogleFonts.nunito(fontSize: 24),
//               ),
//               TextSpan(
//                 text: 'Schedules',
//                 style: GoogleFonts.nunito(
//                     fontSize: 24,
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
//           child: Expanded(
//             child: Column(
//               children: [
//                 TableCalendar(
//                   locale: 'en_UK',
//                   focusedDay: DateTime.now(),
//                   firstDay: DateTime.utc(2010, 1, 12),
//                   lastDay: DateTime.utc(2050, 12, 31),
//                   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                   rangeStartDay: _rangeStart,
//                   rangeEndDay: _rangeEnd,
//                   calendarFormat: _calendarFormat,
//                   rangeSelectionMode: _rangeSelectionMode,
//                   eventLoader: _getEventsForDay,
//                   startingDayOfWeek: StartingDayOfWeek.monday,
//                   calendarStyle: CalendarStyle(
//                     outsideDaysVisible: false,
//                   ),
//                   onDaySelected: _onDaySelected,
//                   onRangeSelected: _onRangeSelected,
//                   onFormatChanged: (format) {
//                     if (_calendarFormat != format) {
//                       setState(() {
//                         _calendarFormat = format;
//                       });
//                     }
//                   },
//                   onPageChanged: (focusedDay) {
//                     _focusedDay = focusedDay;
//                   },
//                 ),
//                 const SizedBox(height: 8.0),
//                 Expanded(
//                   child: ValueListenableBuilder<List<Event>>(
//                     valueListenable: _selectedEvents,
//                     builder: (context, value, _) {
//                       return ListView.builder(
//                         itemCount: value.length,
//                         itemBuilder: (context, index) {
//                           return Container(
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 12.0,
//                               vertical: 4.0,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(),
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             child: ListTile(
//                               onTap: () => print('${value[index]}'),
//                               title: Text('${value[index]}'),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
