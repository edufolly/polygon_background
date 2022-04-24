import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
///
///
enum DrawMode {
  triangle,
  trapezium,
  halfTrapezium,
  diamond,
}

///
///
///
enum ColorVariationMode {
  limit, // Limit in range 0 ~ 255.
  mod, // Modulus of division by 255.
  turn,
}

///
///
///
class PolygonBackground extends CustomPainter {
  static final Random rnd = Random();

  final Color baseColor;
  final int minVarX;
  final int maxVarX;
  final int minVarY;
  final int maxVarY;
  final double margin;
  final int minAlpha;
  final int maxAlpha;
  final double radius;
  final double redDivider;
  final double redAdd;
  final double greenDivider;
  final double greenAdd;
  final double blueDivider;
  final double blueAdd;
  final ColorVariationMode colorVariationMode;
  final DrawMode drawMode;
  final bool debug;

  final List<List<Offset>> matrix = <List<Offset>>[];
  final List<MyPolygon> polygons = <MyPolygon>[];

  Size _lastSize = Size.zero;

  ///
  ///
  ///
  PolygonBackground({
    required this.baseColor,
    this.minVarX = 80,
    this.maxVarX = 150,
    this.minVarY = 80,
    this.maxVarY = 150,
    this.margin = 20,
    this.minAlpha = 30,
    this.maxAlpha = 255,
    this.radius = 4,
    this.redDivider = 5,
    this.redAdd = 0.6,
    this.greenDivider = 6,
    this.greenAdd = 0.6,
    this.blueDivider = 5,
    this.blueAdd = 0.6,
    this.colorVariationMode = ColorVariationMode.turn,
    this.drawMode = DrawMode.diamond,
    this.debug = false,
  })  : assert(minVarX >= 0, 'minVarX must be greater than zero.'),
        assert(maxVarX >= 0, 'maxVarX must be greater than zero.'),
        assert(minVarY >= 0, 'minVarY must be greater than zero.'),
        assert(maxVarY >= 0, 'maxVarY must be greater than zero.'),
        assert(margin >= 0, 'margin must be greater than zero.'),
        assert(
            margin < (minVarX < minVarY ? minVarX : minVarY) / 2,
            'margin must be less than '
            '${(minVarX < minVarY ? minVarX : minVarY) / 2}.'),
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

    /// Define XS
    List<double> xs = <double>[];

    double x = 0;

    do {
      xs.add(x);

      x += minVarX + rnd.nextInt(maxVarX - minVarX);
    } while (x < size.width - minVarX);

    xs.add(size.width);

    if (debug) {
      if (kDebugMode) {
        print('xs: $xs - ${xs.length}');
      }
    }

    /// First Line
    List<Offset> points = <Offset>[];

    for (double x in xs) {
      points.add(Offset(x, 0));
    }

    matrix.add(points);

    /// Define YS
    int y = minVarY + rnd.nextInt(maxVarY - minVarY);

    List<double> ys = <double>[];

    while (y < size.height - minVarY) {
      ys.add(y.toDouble());
      y += minVarY + rnd.nextInt(maxVarY - minVarY);
    }

    ys.add(size.height);

    if (ys.length.isOdd) {
      ys.add(size.height + minVarY + rnd.nextInt(maxVarY - minVarY));
    }

    if (debug) {
      if (kDebugMode) {
        print('ys: $ys - ${ys.length}');
      }
    }

    /// More lines
    for (int i = 0; i < ys.length; i++) {
      double y = ys[i];

      points = <Offset>[];
      List<Offset> lastLine = matrix.last;

      /// First point
      if (matrix.length.isEven) {
        points.add(Offset(0, y));
        if (debug) {
          if (kDebugMode) {
            print('(i:$i, j:-1) => (x:0, y:$y)');
          }
        }
      }

      /// YS points
      for (int j = 0; j < lastLine.length - 1; j++) {
        int prevX = (lastLine[j].dx + margin).toInt();

        int nextX = (lastLine[j + 1].dx - margin).toInt();

        int dx = prevX + rnd.nextInt(nextX - prevX);

        x = dx.toDouble();

        if (i < ys.length - 1) {
          int prevY = (ys[i] + margin).toInt();

          int nextY = (ys[i + 1] - margin).toInt();

          int dy = prevY + rnd.nextInt(nextY - prevY);

          y = dy.toDouble();
        }

        points.add(Offset(x, y));

        if (debug) {
          if (kDebugMode) {
            print('(i:$i, j:$j) => (x:$x, y:$y)');
          }
        }
      }

      /// Last Point
      if (matrix.length.isEven) {
        points.add(Offset(size.width, y));
        if (debug) {
          if (kDebugMode) {
            print('(i:$i, j:${lastLine.length}) => (x:${size.width}, y:$y)');
          }
        }
      }

      matrix.add(points);

      x = 0;
    }

    switch (drawMode) {
      case DrawMode.triangle:
        _drawTriangles();
        break;
      case DrawMode.trapezium:
        _drawTrapeziums();
        break;
      case DrawMode.halfTrapezium:
        _drawHalfTrapeziums();
        break;
      case DrawMode.diamond:
        _drawDiamonds();
        break;
    }

    _lastSize = size;
  }

  ///
  ///
  ///
  void _drawTriangles() {
    for (int i = 0; i < matrix.length - 1; i += 2) {
      for (int j = 0; j < matrix[i].length - 1; j++) {
        polygons.addAll(
          <MyPolygon>[
            /// Left
            MyPolygon(
              points: <Offset>[
                matrix[i][j],
                matrix[i + 1][j],
                matrix[i + 2][j],
              ],
              color: color,
            ),

            /// Top
            MyPolygon(
              points: <Offset>[
                matrix[i][j],
                matrix[i + 1][j],
                matrix[i][j + 1],
              ],
              color: color,
            ),

            /// Right
            MyPolygon(
              points: <Offset>[
                matrix[i][j + 1],
                matrix[i + 1][j],
                matrix[i + 2][j + 1],
              ],
              color: color,
            ),

            /// Bottom
            MyPolygon(
              points: <Offset>[
                matrix[i + 1][j],
                matrix[i + 2][j],
                matrix[i + 2][j + 1],
              ],
              color: color,
            ),
          ],
        );
      }
    }
  }

  ///
  ///
  ///
  void _drawTrapeziums() {
    for (int i = 0; i < matrix.length - 1; i += 2) {
      for (int j = 0; j < matrix[i].length - 1; j++) {
        polygons.add(
          MyPolygon(
            points: <Offset>[
              matrix[i][j],
              matrix[i][j + 1],
              matrix[i + 2][j + 1],
              matrix[i + 2][j],
            ],
            color: color,
          ),
        );
      }
    }
  }

  ///
  ///
  ///
  void _drawHalfTrapeziums() {
    for (int i = 0; i < matrix.length - 1; i += 2) {
      for (int j = 0; j < matrix[i].length - 1; j++) {
        polygons.addAll(
          <MyPolygon>[
            /// Left - Top
            MyPolygon(
              points: <Offset>[
                matrix[i][j],
                matrix[i][j + 1],
                matrix[i + 2][j],
              ],
              color: color,
            ),

            /// Right - Bottom
            MyPolygon(
              points: <Offset>[
                matrix[i][j + 1],
                matrix[i + 2][j],
                matrix[i + 2][j + 1],
              ],
              color: color,
            ),
          ],
        );
      }
    }
  }

  ///
  ///
  ///
  void _drawDiamonds() {
    for (int i = 0; i < matrix.length - 1; i++) {
      if (i.isEven) {
        if (i == 0) {
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
        }

        for (int j = 0; j < matrix[i].length - 1; j++) {
          if (j == 0) {
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
          } else {
            polygons.add(
              MyPolygon(
                points: <Offset>[
                  matrix[i][j],
                  matrix[i + 1][j - 1],
                  matrix[i + 2][j],
                  matrix[i + 1][j],
                ],
                color: color,
              ),
            );
          }
        }

        int j = matrix[i].length - 1;

        polygons.add(
          MyPolygon(
            points: <Offset>[
              matrix[i][j],
              matrix[i + 1][j - 1],
              matrix[i + 2][j],
            ],
            color: color,
          ),
        );
      } else {
        for (int j = 0; j < matrix[i].length; j++) {
          if (i < matrix.length - 2) {
            polygons.add(
              MyPolygon(
                points: <Offset>[
                  matrix[i][j],
                  matrix[i + 1][j],
                  matrix[i + 2][j],
                  matrix[i + 1][j + 1],
                ],
                color: color,
              ),
            );
          } else {
            polygons.add(
              MyPolygon(
                points: <Offset>[
                  matrix[i][j],
                  matrix[i + 1][j],
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

    if (debug) {
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
      .withRed(variation(baseColor.red, redDivider, redAdd, colorVariationMode))
      .withGreen(variation(
          baseColor.green, greenDivider, greenAdd, colorVariationMode))
      .withBlue(
          variation(baseColor.blue, blueDivider, blueAdd, colorVariationMode));

  ///
  ///
  ///
  int variation(int base, double divider, double add, ColorVariationMode mode) {
    int variation = (base * (rnd.nextDouble() / divider + add)).toInt();
    switch (mode) {
      case ColorVariationMode.limit:
        return max(0, min(variation, 255));
      case ColorVariationMode.mod:
        return variation % 255;
      case ColorVariationMode.turn:
        return turn(variation);
    }
  }

  ///
  ///
  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is PolygonBackground) {
      return baseColor != oldDelegate.baseColor ||
          drawMode != oldDelegate.drawMode;
    }
    return false;
  }

  ///
  ///
  ///
  static int turn(int n) => (n < 0)
      ? turn(n * -1)
      : (n > 255)
          ? ((n ~/ 255).isOdd)
              ? 255 - n % 255
              : n % 255
          : n;
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
