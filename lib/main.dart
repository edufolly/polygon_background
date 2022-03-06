import 'package:flutter/material.dart';
import 'package:polygon_background/polygon_background_painter.dart';

///
///
///
void main() {
  runApp(const MyApp());
}

///
///
///
class MyApp extends StatelessWidget {
  ///
  ///
  ///
  const MyApp({Key? key}) : super(key: key);

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polygon Background',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

///
///
///
class MyHomePage extends StatefulWidget {
  ///
  ///
  ///
  const MyHomePage({Key? key}) : super(key: key);

  ///
  ///
  ///
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

///
///
///
class _MyHomePageState extends State<MyHomePage> {
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygon Background'),
      ),
      body: CustomPaint(
        painter: PolygonBackgroundPainter(context),
        child: const Center(
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Polygon Background', textScaleFactor: 3,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
