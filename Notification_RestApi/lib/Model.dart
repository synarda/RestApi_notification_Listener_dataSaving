import 'package:dio/dio.dart';
import 'global.dart';

class NotificationSave{
  String? title ;
  String? text;
  String? packageName;
  NotificationSave({required this.title,required this.text, required packageName});

}


abstract class Services{
  static Future<NotificationSave?> createUser(String title,  String text, String packageName,) async{
    try {
      var response =await Dio().post("https://crudcrud.com/api/${data.toString()}/arda",data: {
        "title": title,
        "text": text,
        "packageName": packageName,

      });
      if(response.statusCode == 201){
        return NotificationSave(title: response.data["data"]["title"], text:response.data["data"]["text"],packageName: response.data["data"]["packageName"] );
      }
    }
    catch(e){}
  }

}