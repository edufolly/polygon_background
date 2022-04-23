import 'package:polygon_background/polygon_background.dart';

///
///
///
class DrawModeParser {
  ///
  ///
  ///
  static String getName(DrawMode mode) {
    switch (mode) {
      case DrawMode.triangle:
        return 'Triangles';
      case DrawMode.trapezium:
        return 'Trapezium';
      case DrawMode.diamond:
        return 'Diamond';
    }
  }
}
