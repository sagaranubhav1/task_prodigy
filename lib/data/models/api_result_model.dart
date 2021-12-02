class ApiResultModel {
  List<dynamic> imageList;

  ApiResultModel({this.imageList});

  ApiResultModel.fromJson(List<dynamic>json) {
      imageList = <dynamic>[];
      for (var v in json) {
        imageList.add(v);
      }
    }
  }
