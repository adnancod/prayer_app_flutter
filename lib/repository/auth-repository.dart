

import 'package:prayer_app/model/PrayerModel.dart';
import 'package:prayer_app/model/prayer_monthly_model.dart';
import 'package:prayer_app/res/app_url.dart';
import 'package:prayer_app/view/monthly_prayers_screen.dart';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiServices.dart';

class AuthRepository{

  BaseApiServices _apiServices = NetworkApiServices();

  Future<PrayerModel> prayerApi()async{

    try{
      dynamic response= await _apiServices.getGetApiResponse(AppUrl.baseUrl);
      return response=PrayerModel.fromJson(response);
    }catch(e){
      throw e;
    }
  }

  Future<PrayerMonthlyModel> monthlyPrayerApi()async{

    try{
      dynamic response= await _apiServices.getGetApiResponse(AppUrl.monthUrl);
      return response=PrayerMonthlyModel.fromJson(response);
    }catch(e){
      throw e;
    }
  }

}