import 'package:flutter/material.dart';

///
///
///
class PopupMenuColor extends PopupMenuItem<Color> {
  ///
  ///
  ///
  PopupMenuColor({
    required String label,
    Color? color,
    bool enabled = true,
    Key? key,
  }) : super(
          key: key,
          value: color ?? Colors.transparent,
          enabled: enabled,
          child: Row(
            children: <Widget>[
              Icon(
                color == null ? Icons.color_lens : Icons.square,
                color: color,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(label),
              ),
            ],
          ),
        );
}
