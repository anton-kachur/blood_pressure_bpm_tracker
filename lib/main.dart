import 'package:blood_pressure_bpm_tracker/App.dart';
import 'package:blood_pressure_bpm_tracker/recordings/Recording.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


void main() async {   
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final appDocDir = await getApplicationDocumentsDirectory();
  
  Hive
    ..init(appDocDir.path)
    ..registerAdapter<Recording>(RecordingAdapter())
    ..initFlutter();

  runApp(const App());
}