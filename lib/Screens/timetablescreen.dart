import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<String> slots = [
    "Booked",
    "Booked",
    "Free",
    "Booked",
    "Free",
    "Booked",
    "Booked",
    "Booked",
    "Free",
    "Free",
    "Booked",
    "Free",
    "Booked"
  ];
  List<DateTime> _currentWeek = [];
  DateTime? _selectedDate; // Add this to keep track of the selected date

  List<Map<DateTime, String>> todayslots = [];

  @override
  void initState() {
    super.initState();
    _currentWeek = _getCurrentWeek();
    _selectedDate = DateTime.now(); // Default to today's date
    _generateHourlySlots(); // Generate hourly slots for the selected date
  }

  List<DateTime> _getCurrentWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;

    // Calculate the start of the week (Monday)
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    // Generate the list of dates for the week
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  void _generateHourlySlots() {
    DateTime startTime = DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, 8, 0); // Starting at 8:00 AM
    DateTime endTime = DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, 21, 0); // Ending at 9:00 PM

    List<DateTime> hourlySlots = [];
    List<Map<DateTime, String>> tempSlots = [];

    while (startTime.isBefore(endTime)) {
      hourlySlots.add(startTime);
      startTime =
          startTime.add(const Duration(hours: 1)); // Increment by 1 hour
    }

    for (int i = 0; i < hourlySlots.length; i++) {
      tempSlots.add({hourlySlots[i]: slots[i]});
    }

    setState(() {
      todayslots = tempSlots;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String name = arguments?['name'] ?? 'Unknown Shop';
    final String charge = arguments?['charge'] ?? 'Unknown Charge';
    final String location = arguments?['location'] ?? 'Unknown Location';
    final String mainImage = arguments?['image'] ?? 'assets/images/Im1.png';
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Table"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            SizedBox(
              width: screenWidth,
              height: 150,
              child: Card(
                elevation: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd MMMM')
                                .format(_selectedDate ?? DateTime.now()),
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _currentWeek = _currentWeek
                                    .map((date) =>
                                        date.subtract(const Duration(days: 7)))
                                    .toList();
                                _selectedDate = DateTime
                                    .now(); // Update _selectedDate when navigating weeks
                                _generateHourlySlots(); // Update slots
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _currentWeek = _currentWeek
                                    .map((date) =>
                                        date.add(const Duration(days: 7)))
                                    .toList();
                                _selectedDate = DateTime
                                    .now(); // Update _selectedDate when navigating weeks
                                _generateHourlySlots(); // Update slots
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _currentWeek.map((date) {
                          bool isSelected = _selectedDate?.day == date.day &&
                              _selectedDate?.month == date.month &&
                              _selectedDate?.year == date.year;
                          return GestureDetector(
                            onTap: () {
                              if (date.isAfter(DateTime.now()
                                  .subtract(const Duration(days: 1)))) {
                                setState(() {
                                  _selectedDate = date;
                                  _generateHourlySlots(); // Update slots when date changes
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: date.isAfter(DateTime.now()
                                        .subtract(const Duration(days: 1)))
                                    ? (isSelected
                                        ? Colors.orange
                                        : Colors.transparent)
                                    : Colors
                                        .grey, // Background color for past dates
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('E').format(
                                        date), // Day of the week (e.g., Mon)
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: date.isAfter(DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1)))
                                            ? (isSelected
                                                ? Colors.white
                                                : Colors.grey)
                                            : Colors
                                                .white), // Text color for past dates
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd')
                                        .format(date), // Date (e.g., 21 Aug)
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: date.isAfter(DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1)))
                                            ? (isSelected
                                                ? Colors.white
                                                : Colors.black)
                                            : Colors
                                                .white), // Text color for past dates
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todayslots.length,
                itemBuilder: (context, index) {
                  var entry = todayslots[index];
                  DateTime slot = entry.keys.first;
                  String slotStatus = entry.values.first;
                  DateTime nextSlot = slot.add(const Duration(hours: 1));
                  return InkWell(
                    onTap: () {
                      // Show bottom sheet on tap
                      if (slotStatus == "Free") {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              width: screenWidth,
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Summary',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    mainImage,
                                    height: 200,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    'Time: ${DateFormat.jm().format(slot)} - ${DateFormat.jm().format(nextSlot)}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Location: $location",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Price per Person: $charge",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    'Status: $slotStatus',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF24BAEC),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                // Update the slot status to 'Booked' for the selected slot
                                                todayslots[index] = {
                                                  slot: 'Booked'
                                                };
                                              });
                                              Navigator.pop(
                                                  context); // Close the bottom sheet

                                              // Show the GIF in an AlertDialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/bookingdone.gif',
                                                          fit: BoxFit.cover,
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        const Text(
                                                          'Booking Confirmed!',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child:
                                                            const Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text(
                                              "Book Now",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        // Optionally handle cases where slotStatus is not 'Free'
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('This slot is not available for booking.'),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Text(
                        '${DateFormat.jm().format(slot)} - ${DateFormat.jm().format(nextSlot)}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      title: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: slotStatus == "Booked"
                              ? Colors.orange
                              : Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            slotStatus,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
