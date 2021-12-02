import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:softprodigy_task/data/models/api_result_model.dart';
import 'package:softprodigy_task/res/strings.dart';

abstract class HomeRepository {
  Future<List<dynamic>> getImages();
}

class HomeRepositoryImpl implements HomeRepository {

  @override
  Future<List<dynamic>> getImages() async {
    var response = await http.get(AppStrings.url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> imageResponseList = ApiResultModel.fromJson(data).imageList;
      print(imageResponseList);
      return imageResponseList;
    } else {
      throw Exception();
    }
  }
}
