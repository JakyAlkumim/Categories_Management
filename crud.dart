import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

String _basicAuth = 'Basic ${base64Encode(utf8.encode(
        'jaky:jaky1234'))}';

Map<String, String> myheaders = {
  'authorization': _basicAuth
};


class Crud {
  Future getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("خطاء في الوصول للسيرفر ${response.statusCode}");
      }
    } catch (e) {
      print("تاكد من الاتصال بالانترنت او السيرفر او ان هناك خطاء في الوصول للسيرفر$e");
    }
  }

  Future postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data,headers: myheaders);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("خطاء في الوصول للسيرفر ${response.statusCode}");
      }
    } catch (e) {
      print("تاكد من الاتصال بالانترنت او السيرفر او ان هناك خطاء في الوصول للسيرفر$e");
    }
  }
  Future postRequestWithFile(String url,Map data,File? file) async{
   try{
     var request = http.MultipartRequest("POSt", Uri.parse(url));
     if(file != null){
       var length = await file.length();
       var stream = http.ByteStream(file.openRead());
       var multiPartFile = http.MultipartFile("file", stream, length,filename: basename(file.path));
       request.headers.addAll(myheaders);
       request.files.add(multiPartFile);
     }
     data.forEach((key,value){
       request.fields[key] = value;
     });
     var myRequest = await request.send();
     var response = await http.Response.fromStream(myRequest);
     if(myRequest.statusCode == 200){
       return jsonDecode(response.body);
     }else{
       print("خطاء في ارسال الطلب ${response.statusCode}");
     }
   }catch(e){
     print("تاكد من الاتصال بالانترنت او السيرفر او ان هناك خطاء في الوصول للسيرفر$e");
   }

  }
}
