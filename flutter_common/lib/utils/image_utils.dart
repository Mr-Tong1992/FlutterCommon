import 'package:flutter/cupertino.dart';
import 'package:flutter_common/flutter_common.dart';

class ToonImage {
  /// 网络图片
  static Widget networkImage({@required String url,
    double width,
    double height,
    Color color,
    BoxFit fit}) {
    if (url.isNotEmpty) {
      return Image.network(url, width: width, height: height, fit: fit);
    } else {
      return Container(
          color: ColorUtils.kColor9C9C9C, width: width, height: height);
    }
  }
}
