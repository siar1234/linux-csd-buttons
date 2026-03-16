import 'package:flutter/material.dart';
import 'theme.dart';

class CsdButton extends StatefulWidget {
  final CsdTheme theme;
  final CsdButtonType type;
  final void Function() onPressed;

  const CsdButton({super.key, required this.theme, required this.type, required this.onPressed});

  @override
  State<CsdButton> createState() => _CsdButtonState();
}

class _CsdButtonState extends State<CsdButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final style = switch(widget.type) {
      CsdButtonType.close => widget.theme.close,
      CsdButtonType.minimize => widget.theme.minimize,
      CsdButtonType.maximize => widget.theme.maximize,
      CsdButtonType.restore => widget.theme.restore
    };
    final normal = Theme.brightnessOf(context) == Brightness.light ? style.normal.light : style.normal.dark;
    final hover = Theme.brightnessOf(context) == Brightness.light ? style.hover.light : style.hover.dark;
    final pressed = Theme.brightnessOf(context) == Brightness.light ? style.pressed.light : style.pressed.dark;
    return MouseRegion(
      onEnter: (d) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (d) {
        setState(() {
          hovering = false;
        });
      },
      child: Padding(
        padding: style.padding,
        child: SizedBox(
          width: style.width,
          height: style.height,
          child: Material(
            color: normal.backgroundColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: normal.borderColor ?? Colors.transparent,
                width: style.normal.borderWidth ?? 0
              ),
              borderRadius: style.borderRadius,
            ),
            child: InkWell(
                mouseCursor: SystemMouseCursors.basic,
                highlightColor: pressed.backgroundColor,
                hoverColor: hover.backgroundColor,
                borderRadius: style.borderRadius,
                onTap: widget.onPressed,
                child: Center(child: hovering ? hover.icon : normal.icon)
            ),
          ),
        ),
      ),
    );
  }
}

enum CsdButtonType { close, minimize, maximize, restore }
