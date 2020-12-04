class ImageFormater{
  List checkImageFormatAndSkip(List list,String index) {
    final base64ImageString = list.map((map) {
      String photoNews = map[index].toString().replaceRange(0, 11, '');
      String imageType = photoNews.substring(0, 3);
      if (imageType == "jpg" || imageType == "png") {
        photoNews = photoNews.replaceRange(0, 11, "");
      } else if (imageType == "jpe") {
        photoNews = photoNews.replaceRange(0, 12, '');
      }
      map[index] = photoNews;
      return map;
    }).toList();
    return base64ImageString;
  }
  /* List checkCompanyLogoImageFormatAndSkip(List list) {
    final base64ImageString = list.map((map) {
      String photoNews = map['Logo'].toString().replaceRange(0, 11, '');
      String imageType = photoNews.substring(0, 3);
      if (imageType == "jpg" || imageType == "png") {
        photoNews = photoNews.replaceRange(0, 11, "");
      } else if (imageType == "jpe") {
        photoNews = photoNews.replaceRange(0, 12, '');
      }
      map['Logo'] = photoNews;
      return map;
    }).toList();
    return base64ImageString;
  } */
}