import 'package:blood_pressure_bpm_tracker/app_utils/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

// **************************************************************************
// Classes for adding new recordings and their states
// **************************************************************************

class NewRecord extends StatefulWidget {
  const NewRecord({super.key});

  @override
  State<NewRecord> createState() => NewRecordState();
}


class NewRecordState extends State<NewRecord> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  int systolic = 100;
  int diastolic = 100;
  int pulse = 100;

  /// Builds a widget which represents single recording data
  /// 
  /// Returns Container with [record] data in it
  Container buildNumberPickerItem(String text, String description) => Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          Text(
            text, 
            style: const TextStyle(
              color: Color.fromARGB(255, 44, 163, 250), fontSize: 20, 
              fontWeight: FontWeight.w500
            )
          ),

          Text(
            description, 
            style: const TextStyle(
              color: Color.fromARGB(255, 44, 163, 250), fontSize: 12, 
              fontWeight: FontWeight.w500
            )
          ),

          NumberPicker(
            minValue: 0, maxValue: 200, 
            value: text == 'Systolic' ? systolic : 
              text == 'Diastolic' ? diastolic : pulse, 
            
            textStyle: const TextStyle(
              color: Color.fromARGB(114, 44, 164, 250), 
              fontSize: 18, fontWeight: FontWeight.w500
            ),

            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(190, 127, 133, 140),
                  width: 1
                ),
                top: BorderSide(
                  color: Color.fromARGB(190, 127, 133, 140),
                  width: 1
                )
              )
            ),

            selectedTextStyle: const TextStyle(
              color: Color.fromARGB(255, 44, 163, 250), 
              fontSize: 20, fontWeight: FontWeight.w500
            ),

            onChanged: (value) { 
              if (text == 'Systolic') { systolic = value; } 
              else if (text == 'Diastolic') { diastolic = value; } 
              else { pulse = value; }
              setState(() {});
            }
          )
        ],
      ),
    );

  @override
  Widget build(BuildContext context) {
    // get recordings from Hive DB
    var recordings = getRecordings(); 

    return FutureBuilder(
      future: recordings,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return waitingOrErrorWindow(context, text: '${snapshot.error}');
        } else {
          return Scaffold(
            appBar: defaultAppBar(title: 'New Record'),
            
            body: Center(
              child: Column(
                children: [          
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildNumberPickerItem('Systolic', '(mmHg)'),
                      buildNumberPickerItem('Diastolic', '(mmHg)'),
                      buildNumberPickerItem('Pulse', '(BMP)'),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Date & Time', 
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 3, 76, 129), fontSize: 26, 
                      fontWeight: FontWeight.w700
                    )
                  ),   

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                      // 'Date' button
                      TextButton.icon(
                        label: Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate), 
                          style: const TextStyle(
                            color: Color.fromARGB(255, 44, 163, 250), 
                            fontSize: 16
                          )
                        ),
                        icon: const Icon(Icons.calendar_today_rounded, size: 19),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.46, 
                            MediaQuery.of(context).size.height * 0.07
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        onPressed: () async {
                          final DateTime? dateTime = await showDatePicker(
                            context: context, 
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000)
                          );

                          if (dateTime != null) {
                            selectedDate = dateTime;
                            setState(() {});
                          }
                        },
                      ),

                      // 'Time' button
                      TextButton.icon(
                        label: Text(
                          '${'${selectedTime.hour}'.padLeft(2, '0')}:${'${selectedTime.minute}'.padLeft(2, '0')}', 
                          style: const TextStyle(
                            color: Color.fromARGB(255, 44, 163, 250), 
                            fontSize: 16
                          )
                        ),
                        icon: const Icon(Icons.access_time_rounded, size: 19),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.46, 
                            MediaQuery.of(context).size.height * 0.07
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        onPressed: () async {
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context, 
                            initialTime: selectedTime,
                            initialEntryMode: TimePickerEntryMode.dial,
                          );

                          if (timeOfDay != null) {
                            selectedTime = timeOfDay;
                            setState(() {});
                          }
                        },
                      ),

                    ],
                  ),

                  const SizedBox(height: 10),

                  // 'Save' button
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 76, 129),
                      shadowColor: Colors.transparent,
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.95, 
                        MediaQuery.of(context).size.height * 0.07
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    onPressed: (){
                      setState(() { 
                        saveNewRecording(systolic, diastolic, pulse,
                          selectedDate, selectedTime); 
                      });
                    },
                    child: const Text(
                      'Save', 
                      style: TextStyle(
                        color: Colors.white, fontSize: 20, 
                        fontWeight: FontWeight.w500
                      )
                    ),
                  )

                ]
              ),
            ),
          );
        }
      }
    );
  }
}
