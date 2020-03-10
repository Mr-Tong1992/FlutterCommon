import 'dart:core';

/// 是否显示边框
class TBorders {

  TBorders();

  TBorders.only({
    this.left = false,
    this.right = false,
    this.top = false,
    this.bottom = false,
  });


  TBorders.all(bool isTrue)
    : left = isTrue,
      right = isTrue,
      top = isTrue,
      bottom = isTrue;

  static TBorders notTrue = TBorders.only();

  bool left = false;

  @override
  bool get _left => left;

  bool right = false;

  @override
  bool get _right => right;

  bool top = false;

  @override
  bool get _top => top;

  bool bottom = false;

  @override
  bool get _bottom => bottom;
}
