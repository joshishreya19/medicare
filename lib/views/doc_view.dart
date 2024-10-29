
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mediapp/consts/colors.dart';
// import 'package:mediapp/controlers/auth_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class DocView extends StatefulWidget {
//   const DocView({Key? key}) : super(key: key);

//   @override
//   State<DocView> createState() => _DocViewState();
// }

// class _DocViewState extends State<DocView> {
//   Set<String> completedAppointments = Set<String>();

//   void _deleteAppointment(String appointmentId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('appointments')
//           .doc(appointmentId)
//           .delete();
//     } catch (e) {
//       print('Error deleting appointment: $e');
//     }
//   }

//   void _toggleCompletion(String appointmentId) {
//     setState(() {
//       if (completedAppointments.contains(appointmentId)) {
//         completedAppointments.remove(appointmentId);
//       } else {
//         completedAppointments.add(appointmentId);
//         _deleteAppointment(appointmentId);
//       }
//     });
//   }

//   DateTime _parseDateTime(String date, String time) {
//     final DateFormat dateFormatter = DateFormat('d-M-yyyy');
//     final DateFormat timeFormatter = DateFormat('HH:mm');
//     DateTime parsedDate = dateFormatter.parse(date);
//     DateTime parsedTime = timeFormatter.parse(time);
//     return DateTime(parsedDate.year, parsedDate.month, parsedDate.day,
//         parsedTime.hour, parsedTime.minute);
//   }

//   void _showKnowledgeDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Important Note"),
//           content: Text(
//             "Note: When you click on the checkbox, the appointment will be deleted. Only click on it once you have finished the appointment.",
//             style: TextStyle(fontSize: 14, color: Colors.red),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child:
//                   Text("OK", style: TextStyle(color: AppColors.primaryColor)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         title: Text(
//           "Booked Appointments",
//           style: TextStyle(
//             color: AppColors.whiteColor,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               AuthController().signout();
//             },
//             icon: Icon(
//               Icons.power_settings_new_rounded,
//               color: AppColors.whiteColor,
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               margin: EdgeInsets.all(8.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Welcome Doctor!",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       "Please press here to get more knowledge.",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     ElevatedButton(
//                       onPressed: _showKnowledgeDialog,
//                       child: Text("Get More Knowledge"),
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: AppColors.whiteColor,
//                         backgroundColor: AppColors.primaryColor,
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection("appointments")
//                   .where("appWith",
//                       isEqualTo: FirebaseAuth
//                           .instance.currentUser?.uid) // Filter by doctor ID
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.active) {
//                   if (snapshot.hasData) {
//                     if (snapshot.data!.docs.isNotEmpty) {
//                       var appointments = snapshot.data!.docs;

//                       // Filter out past appointments
//                       DateTime now = DateTime.now();
//                       appointments = appointments.where((doc) {
//                         DateTime appointmentDate =
//                             _parseDateTime(doc['appDay'], doc['appTime']);
//                         return appointmentDate.isAfter(now) ||
//                             appointmentDate.isAtSameMomentAs(now);
//                       }).toList();

//                       // Sort appointments by date and time
//                       appointments.sort((a, b) {
//                         DateTime dateTimeA =
//                             _parseDateTime(a['appDay'], a['appTime']);
//                         DateTime dateTimeB =
//                             _parseDateTime(b['appDay'], b['appTime']);
//                         return dateTimeA.compareTo(dateTimeB);
//                       });

//                       return ListView.builder(
//                         padding: EdgeInsets.all(8.0),
//                         itemCount: appointments.length,
//                         itemBuilder: (context, index) {
//                           var appointment = appointments[index];
//                           bool isCompleted =
//                               completedAppointments.contains(appointment.id);

//                           // Check if this is the first appointment of a new day
//                           bool isNewDay = index == 0 ||
//                               _parseDateTime(appointments[index - 1]['appDay'],
//                                           appointments[index - 1]['appTime'])
//                                       .day !=
//                                   _parseDateTime(appointment['appDay'],
//                                           appointment['appTime'])
//                                       .day;

//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (isNewDay)
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     DateFormat('EEEE, d MMMM yyyy').format(
//                                         _parseDateTime(appointment['appDay'],
//                                             appointment['appTime'])),
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.primaryColor,
//                                     ),
//                                   ),
//                                 ),
//                               Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 16),
//                                 child: ListTile(
//                                   contentPadding: EdgeInsets.all(16),
//                                   leading: CircleAvatar(
//                                     backgroundColor: AppColors.primaryColor,
//                                     child: Text(
//                                       "${index + 1}",
//                                       style: TextStyle(
//                                           color: AppColors.whiteColor),
//                                     ),
//                                   ),
//                                   title: Text(
//                                     "${appointment["appName"]}",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                       decoration: isCompleted
//                                           ? TextDecoration.lineThrough
//                                           : null,
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                     "${appointment['appDay']} - ${appointment['appTime']}",
//                                     style: TextStyle(
//                                       color:
//                                           AppColors.textColor.withOpacity(0.7),
//                                     ),
//                                   ),
//                                   trailing: Checkbox(
//                                     value: isCompleted,
//                                     onChanged: (value) {
//                                       _toggleCompletion(appointment.id);
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     } else {
//                       return Center(child: Text("No appointments found"));
//                     }
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text("${snapshot.error.toString()}"));
//                   } else {
//                     return Center(child: Text("No data found"));
//                   }
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediapp/consts/colors.dart';
import 'package:mediapp/controlers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DocView extends StatefulWidget {
  const DocView({Key? key}) : super(key: key);

  @override
  State<DocView> createState() => _DocViewState();
}

class _DocViewState extends State<DocView> {
  Set<String> completedAppointments = Set<String>();

  void _deleteAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete();
    } catch (e) {
      print('Error deleting appointment: $e');
    }
  }

  void _toggleCompletion(String appointmentId) {
    setState(() {
      if (completedAppointments.contains(appointmentId)) {
        completedAppointments.remove(appointmentId);
      } else {
        completedAppointments.add(appointmentId);
        _deleteAppointment(appointmentId);
      }
    });
  }

  DateTime _parseDateTime(String date, String time) {
    final DateFormat dateFormatter = DateFormat('d-M-yyyy');
    final DateFormat timeFormatter = DateFormat('HH:mm');
    DateTime parsedDate = dateFormatter.parse(date);
    DateTime parsedTime = timeFormatter.parse(time);
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parsedTime.hour, parsedTime.minute);
  }

  void _showKnowledgeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Important Note"),
          content: Text(
            "Note: When you click on the checkbox, the appointment will be deleted. Only click on it once you have finished the appointment.",
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK", style: TextStyle(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  void _rescheduleAppointment(String appointmentId) async {
    DateTime? newDate = await _selectDateTime(context);
    if (newDate != null) {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'appDay': DateFormat('d-M-yyyy').format(newDate), 'appTime': DateFormat('HH:mm').format(newDate)});
    }
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        return DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Booked Appointments",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthController().signout();
            },
            icon: Icon(
              Icons.power_settings_new_rounded,
              color: AppColors.whiteColor,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Welcome Doctor!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Please press here to get more knowledge.",
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: _showKnowledgeDialog,
                      child: Text("Get More Knowledge"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.whiteColor,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("appointments")
                  .where("appWith",
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid) // Filter by doctor ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      var appointments = snapshot.data!.docs;

                      // Filter out past appointments
                      DateTime now = DateTime.now();
                      appointments = appointments.where((doc) {
                        DateTime appointmentDate = _parseDateTime(doc['appDay'], doc['appTime']);
                        return appointmentDate.isAfter(now) || appointmentDate.isAtSameMomentAs(now);
                      }).toList();

                      // Sort appointments by date and time
                      appointments.sort((a, b) {
                        DateTime dateTimeA = _parseDateTime(a['appDay'], a['appTime']);
                        DateTime dateTimeB = _parseDateTime(b['appDay'], b['appTime']);
                        return dateTimeA.compareTo(dateTimeB);
                      });

                      return ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          var appointment = appointments[index];
                          bool isCompleted = completedAppointments.contains(appointment.id);

                          // Check if this is the first appointment of a new day
                          bool isNewDay = index == 0 ||
                              _parseDateTime(appointments[index - 1]['appDay'], appointments[index - 1]['appTime']).day !=
                                  _parseDateTime(appointment['appDay'], appointment['appTime']).day;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isNewDay)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    DateFormat('EEEE, d MMMM yyyy').format(_parseDateTime(appointment['appDay'], appointment['appTime'])),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primaryColor,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(color: AppColors.whiteColor),
                                    ),
                                  ),
                                  title: Text(
                                    "${appointment["appName"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${appointment['appDay']} - ${appointment['appTime']}",
                                    style: TextStyle(
                                      color: AppColors.textColor.withOpacity(0.7),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.schedule),
                                        color: AppColors.primaryColor,
                                        onPressed: () {
                                          _rescheduleAppointment(appointment.id);
                                        },
                                      ),
                                      Checkbox(
                                        value: isCompleted,
                                        onChanged: (value) {
                                          _toggleCompletion(appointment.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return Center(child: Text("No appointments found"));
                    }
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error.toString()}"));
                  } else {
                    return Center(child: Text("No data found"));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
