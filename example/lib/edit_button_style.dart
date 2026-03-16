
import 'package:example/main.dart';
import 'package:example/theme_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final borderRadiusController = TextEditingController();
  final paddingController = TextEditingController();
  final normalBorderWidthController = TextEditingController();
  final hoverBorderWidthController = TextEditingController();
  final pressedBorderWidthController = TextEditingController();
  Map<String, TextEditingController> iconSizeControllers = {};

  @override
  void initState() {
    final theme = themeState.theme;
    final buttonStyle = switch(widget.type) {
      CsdButtonType.close => theme.close,
      CsdButtonType.minimize => theme.minimize,
      CsdButtonType.maximize => theme.maximize,
      CsdButtonType.restore => theme.restore
    };
    widthController.text = buttonStyle.width.toString();
    heightController.text = buttonStyle.height.toString();
    borderRadiusController.text = buttonStyle.borderRadius.toString();
    paddingController.text = buttonStyle.padding.toString();
    normalBorderWidthController.text = buttonStyle.normal.borderWidth.toString();
    hoverBorderWidthController.text = buttonStyle.hover.borderWidth.toString();
    pressedBorderWidthController.text = buttonStyle.pressed.borderWidth.toString();
    iconSizeControllers.get("Normal_width").text = buttonStyle.normal.iconWidth.toString();
    iconSizeControllers.get("Normal_height").text = buttonStyle.normal.iconHeight.toString();
    iconSizeControllers.get("Hover_width").text = buttonStyle.normal.iconWidth.toString();
    iconSizeControllers.get("Hover_height").text = buttonStyle.normal.iconHeight.toString();
    iconSizeControllers.get("Pressed_width").text = buttonStyle.pressed.iconWidth.toString();
    iconSizeControllers.get("Pressed_height").text = buttonStyle.pressed.iconHeight.toString();
    super.initState();
  }

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
            child: TextField(
              controller: widthController,
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
            child: TextField(
              controller: heightController,
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
            child: TextField(
              controller: borderRadiusController,
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
          _Line(title: "Padding", widget: SizedBox(
            width: 50,
            child: TextField(
              controller: paddingController,
              textAlign: TextAlign.center,
              onChanged: (text) {
                final value = double.tryParse(text);
                if(value is double) {
                  mainScreenKey.currentState?.setState(() {
                    buttonStyle.padding = value;
                  });
                }
              },
            ),
          )),
          ..._stateStyleItems(
            controller: normalBorderWidthController,
            buttonStateStyle: buttonStyle.normal,
            keyword: "Normal"
          ),
          ..._stateStyleItems(
              controller: hoverBorderWidthController,
              buttonStateStyle: buttonStyle.hover,
              keyword: "Hover"
          ),
          ..._stateStyleItems(
              controller: pressedBorderWidthController,
              buttonStateStyle: buttonStyle.pressed,
              keyword: "Pressed"
          ),
        ],
      ),
    );
  }

  List<Widget> _stateStyleItems({required TextEditingController controller, required MutableCsdButtonStateStyle buttonStateStyle, required String keyword}) {
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
        child: TextField(
          controller: iconSizeControllers.get("${keyword}_width"),
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
        child: TextField(
          controller: iconSizeControllers.get("${keyword}_height"),
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
        child: TextField(
          controller: controller,
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
      ..._appearanceItems(appearance: buttonStateStyle.light, keyword: "$keyword Light", prefix: "${keyword}_Light_"),
      ..._appearanceItems(appearance: buttonStateStyle.dark, keyword: "$keyword Dark", prefix: "${keyword}_Dark_")
    ];
  }

  List<Widget> _appearanceItems({required MutableCsdButtonColorAppearance appearance, required String keyword, required String prefix}) {
    return [
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

extension CustomExtension on Map<String, TextEditingController> {
  TextEditingController get(String key) {
    return putIfAbsent(key, () => TextEditingController());
  }
}