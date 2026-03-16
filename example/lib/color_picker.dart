import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color color;
  final void Function(Color) onColorChanged;
  final Color? defaultColor;

  const ColorPickerDialog({super.key, required this.color, required this.onColorChanged, this.defaultColor});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color pickerColor = widget.color;
  bool slider = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 750,
        height: 450,
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 20),
                ),
              ],
            ),
            Switch(
              value: slider,
              onChanged: (value) {
                setState(() {
                  slider = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: slider
                  ? SlidePicker(
                      pickerColor: pickerColor,
                      onColorChanged: (color) {
                        pickerColor = color;
                        widget.onColorChanged(color);
                      },
                    )
                  : ColorPicker(
                      hexInputBar: true,
                      enableAlpha: true,
                      pickerColor: pickerColor,
                      onColorChanged: (color) {
                        pickerColor = color;
                        widget.onColorChanged(color);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
