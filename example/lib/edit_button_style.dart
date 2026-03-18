
import 'package:example/main.dart';
import 'package:example/theme_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linux_csd_buttons/linux_csd_buttons.dart';

import 'color_picker.dart';
import 'mutable_csd_theme.dart';

class EditButtonStyle extends StatefulWidget {
  final CsdButtonType type;
  const EditButtonStyle({super.key, required this.type});

  @override
  State<EditButtonStyle> createState() => _EditButtonStyleState();
}

class _EditButtonStyleState extends State<EditButtonStyle> {
  
  @override
  Widget build(BuildContext context) {
    final mutableTheme = themeState.theme;
    final buttonStyle = switch(widget.type) {
      CsdButtonType.close => mutableTheme.close,
      CsdButtonType.minimize => mutableTheme.minimize,
      CsdButtonType.maximize => mutableTheme.maximize,
      CsdButtonType.restore => mutableTheme.restore
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _Line(title: "Width", widget: SizedBox(
            width: 50,
            child: TextFormField(
              initialValue: buttonStyle.width.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.width = value;
                  });
                }
              },
            ),
          )),
          _Line(title: "Height", widget: SizedBox(
            width: 50,
            child: TextFormField(
              initialValue: buttonStyle.height.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.height = value;
                  });
                }
              },
            ),
          )),
          _Line(title: "Border Radius", widget: SizedBox(
            width: 50,
            child: TextFormField(
              initialValue: buttonStyle.borderRadius?.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.borderRadius = value;
                  });
                }
              },
            ),
          )),
          _Line(title: "Padding Left", widget: SizedBox(
            width: 50,
            child: TextFormField(
              initialValue: buttonStyle.paddingLeft?.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.paddingLeft = value;
                  });
                }
              },
            ),
          )),
          _Line(title: "Padding Right", widget: SizedBox(
            width: 50,
            child: TextFormField(
              initialValue: buttonStyle.paddingRight?.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.paddingRight = value;
                  });
                }
              },
            ),
          )),
          _Line(title: "Padding Top", widget: SizedBox(
            width: 50,
            child: TextFormField(
              initialValue: buttonStyle.paddingTop?.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.paddingTop = value;
                  });
                }
              },
            ),
          )),
          _Line(title: "Padding Bottom", widget: SizedBox(
            width: 50,
            child: TextFormField(
              initialValue: buttonStyle.paddingBottom?.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.paddingBottom = value;
                  });
                }
              },
            ),
          )),
          ..._stateStyleItems(
            buttonStateStyle: buttonStyle.normal,
            keyword: "Normal",
              context: context
          ),
          ..._stateStyleItems(
              buttonStateStyle: buttonStyle.hover,
              keyword: "Hover",
              context: context
          ),
          ..._stateStyleItems(
              buttonStateStyle: buttonStyle.pressed,
              keyword: "Pressed",
            context: context
          ),
        ],
      ),
    );
  }

  List<Widget> _stateStyleItems({required MutableCsdButtonStateStyle buttonStateStyle, required String keyword, required BuildContext context}) {
    final appearance = Theme.brightnessOf(context) == Brightness.light ? buttonStateStyle.light : buttonStateStyle.dark;
    return [
      _Line(title: "$keyword Icon", widget: Row(children: [SvgPicture.string(buttonStateStyle.icon ?? ""), IconButton(onPressed: () async {
        final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["svg"], allowMultiple: false);
        final xFile = result?.files.firstOrNull?.xFile;
        if(xFile != null) {
          final iconData = await xFile.readAsString();
          mainScreenKey.currentState?.setState(() {
            buttonStateStyle.icon = iconData;
          });
        }
      }, icon: Icon(Icons.edit)),
      IconButton(onPressed: () {
        mainScreenKey.currentState?.setState(() {
          buttonStateStyle.icon = null;
        });
      }, icon: Icon(Icons.remove))
      ],)),
      _Line(title: "$keyword Icon Width", widget: SizedBox(
        width: 50,
        child: TextFormField(
          initialValue: buttonStateStyle.iconWidth.toString(),
          textAlign: TextAlign.center,
          onChanged: (text) {
            final value = double.tryParse(text);
            if(value is double) {
              mainScreenKey.currentState?.setState(() {
                buttonStateStyle.iconWidth = value;
              });
            }
          },
        ),
      )),
      _Line(title: "$keyword Icon Height", widget: SizedBox(
        width: 50,
        child: TextFormField(
          initialValue: buttonStateStyle.iconHeight.toString(),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          textAlign: TextAlign.center,
          onChanged: (text) {
            final value = double.tryParse(text);
            if(value is double) {
              mainScreenKey.currentState?.setState(() {
                buttonStateStyle.iconHeight = value;
              });
            }
          },
        ),
      )),
      _Line(title: "$keyword Border Width", widget: SizedBox(
        width: 50,
        child: TextFormField(
          initialValue: buttonStateStyle.borderWidth?.toString(),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          textAlign: TextAlign.center,
          onChanged: (text) {
            final value = double.tryParse(text);
            if(value is double) {
              mainScreenKey.currentState?.setState(() {
                buttonStateStyle.borderWidth = value;
              });
            }
          },
        ),
      )),
      _Line(title: "$keyword Icon Color", widget: Row(
        children: [
          Icon(Icons.circle, color: appearance.iconColor ?? Colors.transparent),
          IconButton(onPressed: () {
            showDialog(context: context, builder: (context) =>
                ColorPickerDialog(color: appearance.iconColor ?? Colors.transparent, onColorChanged: (color) {
                  mainScreenKey.currentState?.setState(() {
                    appearance.iconColor = color;
                  });
                }));
          }, icon: Icon(Icons.edit))
        ],
      )),
      _Line(title: "$keyword Border Color", widget: Row(
        children: [
          Icon(Icons.circle, color: appearance.borderColor ?? Colors.transparent),
          IconButton(onPressed: () {
            showDialog(context: context, builder: (context) =>
                ColorPickerDialog(color: appearance.borderColor ?? Colors.transparent, onColorChanged: (color) {
                  mainScreenKey.currentState?.setState(() {
                    appearance.borderColor = color;
                  });
                }));
          }, icon: Icon(Icons.edit))
        ],
      )),
      _Line(title: "$keyword Background Color", widget: Row(
        children: [
          Icon(Icons.circle, color: appearance.backgroundColor),
          IconButton(onPressed: () {
            showDialog(context: context, builder: (context) =>
                ColorPickerDialog(color: appearance.backgroundColor, onColorChanged: (color) {
                  mainScreenKey.currentState?.setState(() {
                    appearance.backgroundColor = color;
                  });
                }));
          }, icon: Icon(Icons.edit))
        ],
      ))
    ];
  }
}

class _Line extends StatelessWidget {

  final String title;
  final Widget widget;

  const _Line({required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(title, softWrap: true),
        ),
      ),
      widget
    ]);
  }
}