import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:polygon_background/draw_mode_parser.dart';
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
    'Pink': Colors.pink,
    'Blue': Colors.blue,
    'Red': Colors.red,
    'White': Colors.white,
  };

  Color? _selectedColor;

  DrawMode _drawMode = DrawMode.diamond;

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    Color _baseColor = _selectedColor ?? Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygon Background'),
        actions: <Widget>[
          /// Refresh
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),

          /// Draw Mode
          PopupMenuButton<DrawMode>(
            tooltip: 'Draw Mode',
            icon: const Icon(Icons.edit),
            itemBuilder: (BuildContext context) => DrawMode.values
                .map(
                  (DrawMode mode) => PopupMenuItem<DrawMode>(
                    value: mode,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: mode == _drawMode
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.transparent,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(DrawModeParser.getName(mode)),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onSelected: (DrawMode mode) => setState(() => _drawMode = mode),
          ),

          /// Color
          PopupMenuButton<Color>(
            tooltip: 'Color',
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
              const PopupMenuDivider(),
              PopupMenuColor(label: 'Custom'),
            ],
            onSelected: colorSelection,
          ),
        ],
      ),
      body: CustomPaint(
        painter: PolygonBackground(
          baseColor: _baseColor,
          drawMode: _drawMode,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: SelectableText(
                  '0x${_baseColor.hexARGB}',
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
  Future<void> colorSelection(Color color) async {
    if (color == Colors.transparent) {
      await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            alignment: Alignment.bottomRight,
            elevation: 0,
            child: ColorPicker(
              darkMode: Theme.of(context).brightness == Brightness.dark,
              selectedColor: _selectedColor ?? Colors.green,
              onColorSelected: (Color color) => setState(
                () => _selectedColor = color,
              ),
              config: const ColorPickerConfig(
                enableLibrary: false,
                enableEyePicker: false,
                enableOpacity: false,
              ),
              onClose: Navigator.of(context).pop,
            ),
          );
        },
      );
    } else {
      setState(() => _selectedColor = color);
    }
  }
}
