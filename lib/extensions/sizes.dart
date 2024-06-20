import 'package:ludo/common_libs.dart';

extension DeviceSize on BuildContext {
  MediaQueryData get _mediaQuery => MediaQuery.of(this);
  Size get _size => _mediaQuery.size;
  double get bottom => _mediaQuery.viewInsets.bottom;

  double get top => _mediaQuery.padding.top;
  double get screenHeight => _size.height;
  double get screenWidth => _size.width;
}
