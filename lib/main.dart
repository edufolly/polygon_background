import 'package:flutter/material.dart';
import 'package:polygon_background/polygon_background.dart';
import 'package:polygon_background/popup_menu_color.dart';

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
      debugShowCheckedModeBanner: false,
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
  final Map<String, Color> _menuColors = <String, Color>{
    'Green': Colors.green,
    'Purple': Colors.purple,
    'Black': Colors.black,
    'Amber': Colors.amber,
    'Blue': Colors.blue,
    'Red': Colors.red,
    'White': Colors.white,
  };

  Color? _selectedColor;

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygon Background'),
        actions: <Widget>[
          PopupMenuButton<Color>(
            icon: const Icon(Icons.color_lens),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Color>>[
              ..._menuColors.keys
                  .map(
                    (String key) => PopupMenuColor(
                      color: _menuColors[key],
                      enabled: _selectedColor != _menuColors[key],
                      label: key,
                    ),
                  )
                  .toList(),
              // const PopupMenuDivider(),
              // PopupMenuColor(label: 'Custom'),
            ],
            onSelected: colorSelection,
          ),
        ],
      ),
      body: CustomPaint(
        painter: PolygonBackground(
          baseColor: _selectedColor ?? Theme.of(context).colorScheme.primary,
        ),
        child: const Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.black54,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Polygon Background',
                  textScaleFactor: 3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  ///
  ///
  Future<void> colorSelection(Color? color) async {
    if (color != null) {
      setState(() => _selectedColor = color);
    }
  }
}
