import 'package:hive_flutter/hive_flutter.dart';

part 'Recording.g.dart';

// **************************************************************************
// Hive class for blood pressure record
// **************************************************************************

@HiveType(typeId: 0)
class Recording {
  @HiveField(0)
  int systolic;
  @HiveField(1)
  int diastolic;
  @HiveField(2)
  int pulse;  
  @HiveField(3)
  String dateTime;
  
  Recording(this.systolic, this.diastolic, this.pulse, this.dateTime);

  @override
  String toString() {
    return 'Systolic: $systolic, diastolic: $diastolic, pulse: $pulse, date and time: $dateTime\n';
  }
}