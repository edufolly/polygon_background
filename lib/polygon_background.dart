import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
///
///
class PolygonBackground extends CustomPainter {
  static final Random rnd = Random();

  final Color baseColor;
  final int minWidth;
  final int maxWidth;
  final int minHeight;
  final int maxHeight;
  final double widthMargin;
  final int minAlpha;
  final int maxAlpha;
  final bool showPoints;
  final double radius;
  final double redDivider;
  final double redAdd;
  final double greenDivider;
  final double greenAdd;
  final double blueDivider;
  final double blueAdd;
  final bool debug;

  final List<List<Offset>> matrix = <List<Offset>>[];
  final List<MyPolygon> polygons = <MyPolygon>[];

  Size _lastSize = Size.zero;

  ///
  ///
  ///
  PolygonBackground({
    required this.baseColor,
    this.minWidth = 80,
    this.maxWidth = 150,
    this.minHeight = 80,
    this.maxHeight = 150,
    this.widthMargin = 20,
    this.minAlpha = 30,
    this.maxAlpha = 250,
    this.showPoints = false,
    this.radius = 4,
    this.redDivider = 5,
    this.redAdd = 0.9,
    this.greenDivider = 6,
    this.greenAdd = 0.9,
    this.blueDivider = 5,
    this.blueAdd = 0.9,
    this.debug = false,
  })  : assert(
            widthMargin < (minWidth < minHeight ? minWidth : minHeight) / 2,
            'widthMargin must be less than '
            '${(minWidth < minHeight ? minWidth : minHeight) / 2}.'),
        assert(minAlpha >= 0 && minAlpha <= 255,
            'minAlpha must be between 0 and 255.'),
        assert(maxAlpha >= 0 && maxAlpha <= 255,
            'maxAlpha must be between 0 and 255.'),
        assert(maxAlpha > minAlpha, 'maxAlpha must be greater than minAlpha.'),
        assert(radius > 0, 'radius must be greater than zero.');

  ///
  ///
  ///
  void generate(Size size) {
    if (debug) {
      if (kDebugMode) {
        print(size);
      }
    }

    matrix.clear();
    polygons.clear();

    double x = 0;

    if (debug) {
      if (kDebugMode) {
        print('First Line');
      }
    }

    List<Offset> points = <Offset>[];

    do {
      points.add(Offset(x, 0));

      if (debug) {
        if (kDebugMode) {
          print('x: $x');
        }
      }

      x += minWidth + rnd.nextInt(maxWidth - minWidth);
    } while (x < size.width - minWidth);

    points.add(Offset(size.width, 0));

    if (debug) {
      if (kDebugMode) {
        print('x: ${size.width}');
        print('Points Length: ${points.length}');
        print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
      }
    }

    matrix.add(points);

    int y = minHeight + rnd.nextInt(maxHeight - minHeight);

    List<double> ys = <double>[];

    while (y < size.height - minHeight) {
      ys.add(y.toDouble());
      y += minHeight + rnd.nextInt(maxHeight - minHeight);
    }

    ys.add(size.height);

    if (ys.length.isOdd) {
      ys.add(size.height + minHeight + rnd.nextInt(maxHeight - minHeight));
    }

    for (int i = 0; i < ys.length; i++) {
      double y = ys[i];

      points = <Offset>[];
      List<Offset> lastLine = matrix.last;

      if (matrix.length.isEven) {
        points.add(Offset(0, y));
      }

      for (int j = 0; j < lastLine.length - 1; j++) {
        int prevX = (lastLine[j].dx + widthMargin).toInt();

        int nextX = (lastLine[j + 1].dx - widthMargin).toInt();

        if (debug) {
          if (kDebugMode) {
            print('AproxX [$prevX - $nextX]');
          }
        }

        int dx = prevX + rnd.nextInt(nextX - prevX);

        x = dx.toDouble();

        if (debug) {
          if (kDebugMode) {
            print('x: $x');
          }
        }

        if (i > 0 && i < ys.length - 1) {
          int prevY = (ys[i] + widthMargin).toInt();

          int nextY = (ys[i + 1] - widthMargin).toInt();

          if (debug) {
            if (kDebugMode) {
              print('AproxY [$prevY - $nextY]');
            }
          }

          int dy = prevY + rnd.nextInt(nextY - prevY);

          y = dy.toDouble();
        }

        if (debug) {
          if (kDebugMode) {
            print('y: $y');
          }
        }

        points.add(Offset(x, y));
      }

      if (matrix.length.isEven) {
        points.add(Offset(size.width, y));
      }

      if (debug) {
        if (kDebugMode) {
          print('Points Length: ${points.length}');
          print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
        }
      }

      matrix.add(points);

      x = 0;
    }

    if (debug) {
      if (kDebugMode) {
        print('ys: $ys - ${ys.length}');
      }
    }

    _drawModel1();

    _lastSize = size;
  }

  ///
  ///
  ///
  void _drawModel1() {
    for (int i = 0; i < matrix.length - 1; i++) {
      if (i.isEven) {
        for (int j = 0; j < matrix[i].length - 1; j++) {
          polygons.add(
            MyPolygon(
              points: <Offset>[
                matrix[i][j],
                matrix[i][j + 1],
                matrix[i + 1][j],
              ],
              color: color,
            ),
          );
        }

        if (i + 2 < matrix.length) {
          for (int j = 0; j < matrix[i].length - 1; j++) {
            polygons.add(
              MyPolygon(
                points: <Offset>[
                  matrix[i][j],
                  matrix[i + 1][j],
                  matrix[i + 2][j],
                ],
                color: color,
              ),
            );
          }
        }
      } else {
        for (int j = 0; j < matrix[i].length; j++) {
          polygons.add(
            MyPolygon(
              points: <Offset>[
                matrix[i][j],
                matrix[i + 1][j + 1],
                matrix[i + 1][j],
              ],
              color: color,
            ),
          );
        }

        if (i + 1 < matrix.length) {
          for (int j = 0; j < matrix[i].length; j++) {
            polygons.add(
              MyPolygon(
                points: <Offset>[
                  matrix[i][j],
                  matrix[i - 1][j + 1],
                  matrix[i + 1][j + 1],
                ],
                color: color,
              ),
            );
          }
        }
      }
    }
  }

  ///
  ///
  ///
  @override
  void paint(Canvas canvas, Size size) {
    if (_lastSize.width < size.width || _lastSize.height < size.height) {
      generate(size);
    }

    for (MyPolygon polygon in polygons) {
      polygon.draw(canvas);
    }

    if (showPoints) {
      Paint paint = Paint()
        ..color = const Color(0xFFFF0000)
        ..style = PaintingStyle.fill;

      for (List<Offset> points in matrix) {
        for (Offset offset in points) {
          canvas.drawCircle(offset, radius, paint);
        }
      }
    }
  }

  ///
  ///
  ///
  Color get color => baseColor
      .withAlpha(minAlpha + rnd.nextInt(maxAlpha + 1 - minAlpha))
      .withRed(
          (baseColor.red * (rnd.nextDouble() / redDivider + redAdd)).toInt())
      .withGreen(
          (baseColor.green * (rnd.nextDouble() / greenDivider + greenAdd))
              .toInt())
      .withBlue((baseColor.blue * (rnd.nextDouble() / blueDivider + blueAdd))
          .toInt());

  ///
  ///
  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is PolygonBackground) {
      return baseColor != oldDelegate.baseColor;
    }
    return false;
  }
}

///
///
///
class MyPolygon {
  final List<Offset> points;
  final Color color;

  ///
  ///
  ///
  MyPolygon({
    required this.points,
    required this.color,
  });

  ///
  ///
  ///
  Paint get paint => Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  ///
  Path get path => Path()..addPolygon(points, true);

  ///
  ///
  ///
  void draw(Canvas canvas) => canvas.drawPath(path, paint);
}
