import 'package:blood_pressure_bpm_tracker/app_utils/components.dart';
import 'package:blood_pressure_bpm_tracker/recordings/Recording.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// **************************************************************************
// Classes of all history page and its states
// **************************************************************************

class AllHistory extends StatefulWidget {
  const AllHistory({super.key});

  @override
  State<AllHistory> createState() => AllHistoryState();
}


class AllHistoryState extends State<AllHistory> {
  DateTime currentDate = DateTime.now();
  late Box<Recording> recordingsBox;

  @override
  Widget build(BuildContext context) {
    // get recordings from Hive DB
    var recordings = getRecordings(); 

    return FutureBuilder(
      future: recordings,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow(context);
        } else {
          if (snapshot.hasError) {
            return waitingOrErrorWindow(context, text: '${snapshot.error}');
          } else {
            return Scaffold(
              appBar: defaultAppBar(title: 'History'),
              
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Column(
                    children: [          
                      
                      // building a list of ALL recordings
                      for (var recording in snapshot.data)
                        buildItem(recording, context),

                    ]
                  ),
                ),
              )
            );
          }
        }
      }
    );
  }
}
