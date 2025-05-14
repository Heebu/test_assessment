import 'package:stacked/stacked.dart';
import '../../model/time_model.dart';


class HomeViewModel extends BaseViewModel {
  TimeModel today = TimeModel.fromDateTime(DateTime.now());
  DateTime now = DateTime.now();
  DateTime pickedDate = DateTime.now();

  List<DateTime> get daysInMonth {
    return List.generate(
      now.day, // only go up to today
          (index) => DateTime(now.year, now.month, now.day - index),
    );
  }


 void onPickedDate(DateTime picked){
    pickedDate = picked;
    notifyListeners();
    print(picked);
  }

  initFunc(){}
}