import 'package:blood_pressure_bpm_tracker/AllHistory.dart';
import 'package:blood_pressure_bpm_tracker/NewRecord.dart';
import 'package:blood_pressure_bpm_tracker/app_utils/components.dart';
import 'package:flutter/material.dart';

// **************************************************************************
// Classes of main page and its states
// **************************************************************************

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}


class MainPageState extends State<MainPage> {
  
  @override
  Widget build(BuildContext context) {
    // get recordings from Hive DB
    var recordings = getRecordings(amount: 3, last: true); 

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
              appBar: defaultAppBar(title: 'Blood Pressure BPM Tracker'),
              
              body: Center(
                child: Column(
                  children: [          
                    
                    // building a list of 3 recent recordings
                    for (var recording in snapshot.data)
                      buildItem(recording, context),

                    const SizedBox(height: 10),

                    // 'All history' button
                    TextButton.icon(
                      label: const Text(
                        'All history', 
                        style: TextStyle(
                          color: Color.fromARGB(255, 44, 163, 250), 
                          fontSize: 20, fontWeight: FontWeight.w500
                        )
                      ),
                      icon: const Icon(Icons.history_rounded, size: 23),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AllHistory()));
                      },
                    ),

                  ]
                ),
              ),

              floatingActionButton: FloatingActionButton.large(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const NewRecord()));
                },
                backgroundColor: const Color.fromARGB(255, 3, 76, 129),
                tooltip: 'New Record',
                child: const Icon(Icons.add_rounded, size: 48),
              ),

            );
          }
        }
      }
    );
  }
}
