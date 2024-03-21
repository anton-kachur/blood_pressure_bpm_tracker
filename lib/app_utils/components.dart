
import 'package:blood_pressure_bpm_tracker/recordings/Recording.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Creates default AppBar for an application
///
/// Returns AppBar widget
AppBar defaultAppBar({required String title}) { 
  DateTime currentDate = DateTime.now();

  return AppBar(
    title: Text(title),
    shadowColor: Colors.transparent,
    backgroundColor: const Color.fromARGB(255, 3, 76, 129),
    actions: [

      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Row ( 
          children: [
            
            Text(
              '${DateFormat('MMM').format(currentDate).toString()} ${currentDate.day.toString()} ', 
              style: const TextStyle(
                color: Color.fromARGB(225, 255, 255, 255), fontSize: 14, 
                fontWeight: FontWeight.w600
              ),
            ),

            Text(
              DateFormat('EEE').format(currentDate).toString(),
              style: const TextStyle(
                color: Color.fromARGB(225, 255, 255, 255), fontSize: 12, 
                fontWeight: FontWeight.w300
              ),
            ),

          ],
        )
      )
      
    ],
  );
}

/// Gets a certain amount of recordings from Hive DB
///
/// Returns recordings stored in Future.value()
Future getRecordings({int amount = 0, bool last = false}) async {
  Box<Recording> recordingsBox = await Hive.openBox('recordings');

  if (amount != 0 && recordingsBox.length != 0) {
    List<Recording> recordings = [];
    for (int i=amount; i>0; i--) {
      recordings.add(recordingsBox.values.elementAt(recordingsBox.length-i));
    }
    return Future.value(recordings);
  }

  return Future.value(recordingsBox.values);
}

/// Deletes recording by index from Hive DB
///
/// Returns void
void deleteRecording(int index) {

}

/// Saves new recording to Hive DB
///
/// Returns recordings stored in Future.value()
void saveNewRecording(int systolic, int diastolic, int pulse, DateTime date, 
  TimeOfDay time ) async {
  
  Box<Recording> recordingsBox = await Hive.openBox('recordings');

  recordingsBox.put(
    'recording${recordingsBox.length+1}', 
    Recording(
      systolic, diastolic, pulse, 
      '${DateFormat('yyyy-MM-dd').format(date)} ${'${time.hour}'.padLeft(2, '0')}:${'${time.minute}'.padLeft(2, '0')}'
    )  
  );

  recordingsBox.close();
}

/// Creates window which displays loading animation or error message
///
/// Returns widget of the window (read description below)
Container waitingOrErrorWindow(BuildContext context, {String text = ''}) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: const Color.fromARGB(255, 201, 187, 170),
    
    child: 
      Center(
        child: text != '' ? 
        Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.red, decoration: TextDecoration.none)) :
        LoadingAnimationWidget.staggeredDotsWave(
          color: const Color.fromARGB(255, 44, 163, 250),
          size: 100
        )
      )
    );
}

/// Aligns recording data and its description within a Wrap widget (column)
///
/// Returns [data] and [description] stored in Wrap
Wrap wrappedItems(String data, String description) => Wrap(
  direction: Axis.vertical, 
  crossAxisAlignment: WrapCrossAlignment.center, 
  children: [
    Text(
      data, 
      style: const TextStyle(
        color: Color.fromARGB(255, 44, 163, 250), fontSize: 26, 
        fontWeight: FontWeight.w500
      )
    ), 
    
    Text(
      description, 
      style: const TextStyle(
        color: Color.fromARGB(255, 44, 163, 250), fontSize: 12,
        fontWeight: FontWeight.w500
      )
    )
  ]
);

/// Builds a widget which represents single recording data
/// 
/// Returns Container with [record] data in it
Container buildItem(var record, BuildContext context) => Container(
    height: MediaQuery.of(context).size.height * 0.13,
    width: MediaQuery.of(context).size.width * 0.95,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        const Spacer(flex: 3),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            wrappedItems('${record.systolic}', 'Systolic'),
            wrappedItems('${record.diastolic}', 'Diastolic'),
            wrappedItems('${record.pulse}', 'Pulse'),
          ],
        ),
        
        const Spacer(),
        const Divider(thickness: 1, color: Color.fromARGB(255, 44, 163, 250)),
        const Spacer(),
      
        Text(
          DateFormat('HH:mm, dd/MM/yyyy').format(DateTime.parse(record.dateTime)),
          style: const TextStyle(
            color: Color.fromARGB(255, 44, 163, 250), fontSize: 12,
            fontWeight: FontWeight.w400
          )
        ),

        const Spacer(flex: 3),
      ],
    ),
  );