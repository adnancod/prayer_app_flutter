
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../app_exceptions.dart';
import 'BaseApiServices.dart';

class NetworkApiServices extends BaseApiServices{


  @override
  Future getGetApiResponse(String url) async{

    dynamic responseJson;
    try{

      final response=await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson=returnResponse(response);

    }on SocketException{
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response){
    switch(response.statusCode){
      case 200:
        dynamic responseJson=jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException('Error occured while communicating with server with status code'+response.statusCode.toString());
    }
  }

}