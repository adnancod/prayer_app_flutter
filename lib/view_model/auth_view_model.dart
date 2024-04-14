import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:prayer_app/data/response/api_response.dart';
import 'package:prayer_app/model/PrayerModel.dart';
import 'package:prayer_app/model/prayer_monthly_model.dart';

import '../repository/auth-repository.dart';
import '../utils/utils.dart';

class AuthViewModel with ChangeNotifier{

  final _myRepo= AuthRepository();

  ApiResponse<PrayerModel> prayerList= ApiResponse.loading();

  setPrayerList(ApiResponse<PrayerModel> response){
    prayerList=response;
    notifyListeners();
  }

  Future<void> fetchPrayerApi()async{

    setPrayerList(ApiResponse.loading());
    _myRepo.prayerApi().then((value) {
      setPrayerList(ApiResponse.completed(value));
      if(kDebugMode){
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setPrayerList(ApiResponse.error(error.toString()));
      if(kDebugMode){
        print(error.toString());
      }

    });
    notifyListeners();
  }

  ApiResponse<PrayerMonthlyModel> prayerMonthlyList= ApiResponse.loading();

  setPrayerMonthlyList(ApiResponse<PrayerMonthlyModel> response){
    prayerMonthlyList=response;
    notifyListeners();
  }

  Future<void> fetchMonthlyPrayerApi()async{

    setPrayerMonthlyList(ApiResponse.loading());
    _myRepo.monthlyPrayerApi().then((value) {
      setPrayerMonthlyList(ApiResponse.completed(value as PrayerMonthlyModel?));
      if(kDebugMode){
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setPrayerMonthlyList(ApiResponse.error(error.toString()));
      if(kDebugMode){
        print(error.toString());
      }

    });
    notifyListeners();
  }
}