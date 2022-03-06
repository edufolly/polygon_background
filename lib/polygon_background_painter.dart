import 'dart:math';

import 'package:flutter/material.dart';

///
///
///
class PolygonBackgroundPainter extends CustomPainter {
  static final Random rnd = Random();

  final BuildContext context;
  final Color baseColor;
  final int minWidth;
  final int maxWidth;
  final int minHeight;
  final int maxHeight;
  final double widthMargin;
  final int minAlpha;
  final int maxAlpha;
  final double radius;
  final bool showPoints;

  ///
  ///
  ///
  const PolygonBackgroundPainter(
    this.context, {
    this.baseColor = Colors.green,
    this.minWidth = 80,
    this.maxWidth = 150,
    this.minHeight = 80,
    this.maxHeight = 150,
    this.widthMargin = 20,
    this.minAlpha = 30,
    this.maxAlpha = 250,
    this.showPoints = false,
    this.radius = 4,
  })  : assert(widthMargin <= minWidth / 2.0,
            'marginPercent must be less than minWidth / 2.0.'),
        assert(minAlpha >= 0 && minAlpha <= 255,
            'minAlpha mus be between 0 and 255.'),
        assert(maxAlpha >= 0 && maxAlpha <= 255,
            'maxAlpha mus be between 0 and 255.'),
        assert(maxAlpha > minAlpha, 'maxAlpha mus be greater than minAlpha.');

  ///
  ///
  ///
  @override
  void paint(Canvas canvas, Size size) {
    print(size);

    double x = 0;

    List<List<Offset>> matrix = <List<Offset>>[];

    print('First Line');

    List<Offset> points = <Offset>[];

    do {
      points.add(Offset(x, 0));
      print('x: $x');
      x += minWidth + rnd.nextInt(maxWidth - minWidth);
    } while (x < size.width - minWidth);

    points.add(Offset(size.width, 0));
    print('x: ${size.width}');

    print('Points Length: ${points.length}');
    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
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

    for (double y in ys) {
      points = <Offset>[];
      List<Offset> lastLine = matrix.last;

      if (matrix.length.isEven) {
        points.add(Offset(0, y));
      }

      for (int i = 0; i < lastLine.length - 1; i++) {
        double prev = lastLine[i].dx;

        double next = lastLine[i + 1].dx;

        print('Points [$prev - $next]');

        int prevX = (prev + widthMargin).toInt();

        int nextX = (next - widthMargin).toInt();

        print('Aprox [$prevX - $nextX]');

        int dx = prevX + rnd.nextInt(nextX - prevX);

        x = dx.toDouble();

        print('x: $x');

        points.add(Offset(x, y));
      }

      if (matrix.length.isEven) {
        points.add(Offset(size.width, y));
      }

      print('Points Length: ${points.length}');
      print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
      matrix.add(points);

      x = 0;
    }

    print('ys: $ys - ${ys.length}');

    /// Draw
    for (int i = 0; i < matrix.length - 1; i++) {
      if (i.isEven) {
        for (int j = 0; j < matrix[i].length - 1; j++) {
          Path path = Path();

          path.addPolygon(
            List<Offset>.of(<Offset>[
              matrix[i][j],
              matrix[i][j + 1],
              matrix[i + 1][j],
            ]),
            true,
          );

          canvas.drawPath(path, _getPaint());
        }

        if (i + 2 < matrix.length) {
          for (int j = 0; j < matrix[i].length - 1; j++) {
            Path path = Path();

            path.addPolygon(
              List<Offset>.of(<Offset>[
                matrix[i][j],
                matrix[i + 1][j],
                matrix[i + 2][j],
              ]),
              true,
            );

            canvas.drawPath(path, _getPaint());
          }
        }
      } else {
        for (int j = 0; j < matrix[i].length; j++) {
          Path path = Path();

          path.addPolygon(
            List<Offset>.of(<Offset>[
              matrix[i][j],
              matrix[i + 1][j + 1],
              matrix[i + 1][j],
            ]),
            true,
          );

          canvas.drawPath(path, _getPaint());
        }

        if (i + 1 < matrix.length) {
          for (int j = 0; j < matrix[i].length; j++) {
            Path path = Path();

            path.addPolygon(
              List<Offset>.of(<Offset>[
                matrix[i][j],
                matrix[i - 1][j + 1],
                matrix[i + 1][j + 1],
              ]),
              true,
            );

            canvas.drawPath(path, _getPaint());
          }
        }
      }
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
  Paint _getPaint() {
    Color color = baseColor
        .withAlpha(minAlpha + rnd.nextInt(maxAlpha + 1 - minAlpha))
        .withRed((baseColor.red * (rnd.nextDouble() / 5 + 0.9)).toInt())
        .withGreen((baseColor.green * (rnd.nextDouble() / 6 + 0.9)).toInt())
        .withBlue((baseColor.blue * (rnd.nextDouble() / 5 + 0.9)).toInt());

    return Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  ///
  ///
  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
