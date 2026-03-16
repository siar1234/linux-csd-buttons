import 'package:flutter/material.dart';
import 'package:linux_csd_buttons/linux_csd_buttons.dart';

class MutableCsdButtonColorAppearance {
  Color? iconColor;
  Color? borderColor;
  Color backgroundColor;

  MutableCsdButtonColorAppearance({
    this.iconColor,
    required this.borderColor,
    required this.backgroundColor,
  });

  factory MutableCsdButtonColorAppearance.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? base}) {
    final iconColor = json["iconColor"] ?? base?["iconColor"];
    final borderColor = json["borderColor"] ?? base?["borderColor"];
    return MutableCsdButtonColorAppearance(
      iconColor: iconColor is int ? Color(iconColor) : null,
      borderColor: borderColor is int ? Color(borderColor) : null,
      backgroundColor: Color(json["backgroundColor"] ?? base?["backgroundColor"] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{"iconColor": iconColor?.toARGB32(), "borderColor": borderColor?.toARGB32(), "backgroundColor": backgroundColor.toARGB32()};
    return json;
  }
}

class MutableCsdButtonStateStyle {
  String? icon;
  double iconWidth;
  double iconHeight;
  double? borderWidth;
  MutableCsdButtonColorAppearance light;
  MutableCsdButtonColorAppearance dark;

  MutableCsdButtonStateStyle({this.icon,    required this.iconWidth,
    required this.iconHeight, this.borderWidth, required this.light, required this.dark});

  factory MutableCsdButtonStateStyle.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? base}) {
    return MutableCsdButtonStateStyle(
      icon: json["icon"],
      iconWidth: json["iconWidth"] ?? json["iconSize"] ?? 0,
      iconHeight: json["iconHeight"] ?? json["iconSize"] ?? 0,
      borderWidth: json["borderWidth"],
      light: MutableCsdButtonColorAppearance.fromJson(json["light"], base: json),
      dark: MutableCsdButtonColorAppearance.fromJson(json["dark"], base: json),
    );
  }

  Map<String, dynamic> toJson() {
    var json = {"icon": icon, "borderWidth": borderWidth, "light": light.toJson(), "dark": dark.toJson()};
    if (iconWidth == iconHeight) {
      json["iconSize"] = iconWidth;
    } else {
      json["iconWidth"] = iconWidth;
      json["iconHeight"] = iconHeight;
    }
    return json;
  }
}

class MutableCsdButtonStyle {
  double width;
  double height;
  double? borderRadius;
  double? padding;
  MutableCsdButtonStateStyle normal;
  MutableCsdButtonStateStyle hover;
  MutableCsdButtonStateStyle pressed;

  MutableCsdButtonStyle({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.padding,
    required this.normal,
    required this.hover,
    required this.pressed,
  });

  factory MutableCsdButtonStyle.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? base}) {
    return MutableCsdButtonStyle(
      width: json["width"] ?? json["size"] ?? 24,
      height: json["height"] ?? json["size"] ?? 24,
      borderRadius: json["borderRadius"],
      padding: json["padding"],
      normal: MutableCsdButtonStateStyle.fromJson(json["normal"], base: json),
      hover: MutableCsdButtonStateStyle.fromJson(json["hover"], base: json),
      pressed: MutableCsdButtonStateStyle.fromJson(json["pressed"], base: json),
    );
  }

  Map<String, dynamic> toJson() {
    var json = {"borderRadius": borderRadius, "padding": padding, "normal": normal.toJson(), "hover": hover.toJson(), "pressed": pressed.toJson()};
    if (width == height) {
      json["size"] = width;
      return json;
    }
    json["width"] = width;
    json["height"] = height;
    return json;
  }
}

class MutableCsdTheme {
  MutableCsdButtonStyle close;
  MutableCsdButtonStyle minimize;
  MutableCsdButtonStyle maximize;
  MutableCsdButtonStyle restore;

  MutableCsdTheme({required this.close, required this.minimize, required this.maximize, required this.restore});

  factory MutableCsdTheme.fromJson(Map<String, dynamic> json) {
    return MutableCsdTheme(
      close: MutableCsdButtonStyle.fromJson(json["close"]),
      minimize: MutableCsdButtonStyle.fromJson(json["minimize"]),
      maximize: MutableCsdButtonStyle.fromJson(json["maximize"]),
      restore: MutableCsdButtonStyle.fromJson(json["restore"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"close": close.toJson(), "minimize": minimize.toJson(), "maximize": maximize.toJson(), "restore": restore.toJson()};
  }

  CsdTheme toTheme() {
    return CsdTheme.fromJson(toJson());
  }
}
