import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CsdButtonColorAppearance {
  final Widget? icon;
  final Color? borderColor;
  final Color backgroundColor;
  const CsdButtonColorAppearance({this.icon, this.borderColor, required this.backgroundColor});

  factory CsdButtonColorAppearance.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? base}) {
    final icon = base?["icon"];
    return CsdButtonColorAppearance(
        icon: icon is String
            ? SvgPicture.string(icon,
            width: base?["iconWidth"] ?? base?["iconSize"] ?? 0,
            height: base?["iconHeight"] ?? base?["iconSize"] ?? 0,
            colorFilter: ColorFilter.mode(Color(json["iconColor"] ?? 0), BlendMode.srcIn))
            : null,
        borderColor: Color(json["borderColor"] ?? base?["borderColor"] ?? 0), backgroundColor: Color(json["backgroundColor"] ?? base?["backgroundColor"] ?? 0));
  }
}

class CsdButtonStateStyle {
  final double? borderWidth;
  final CsdButtonColorAppearance light;
  final CsdButtonColorAppearance dark;

  const CsdButtonStateStyle({
    this.borderWidth,
    required this.light,
    required this.dark
  });

  factory CsdButtonStateStyle.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? base}) {
    return CsdButtonStateStyle(
        borderWidth: json["borderWidth"],
      light: CsdButtonColorAppearance.fromJson(json["light"], base: json),
      dark: CsdButtonColorAppearance.fromJson(json["dark"], base: json)
    );
  }

}

class CsdButtonStyle {

  final double width;
  final double height;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final CsdButtonStateStyle normal;
  final CsdButtonStateStyle hover;
  final CsdButtonStateStyle pressed;

  const CsdButtonStyle({required this.width, required this.height, required this.borderRadius, required this.padding, required this.normal, required this.hover, required this.pressed});

  factory CsdButtonStyle.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? base}) {
    return CsdButtonStyle(
      width: json["width"] ?? json["size"] ?? 24,
        height: json["height"] ?? json["size"] ?? 24,
        borderRadius: BorderRadius.circular(json["borderRadius"] ?? 0),
        padding: EdgeInsets.symmetric(horizontal: json["padding"] ?? 0),
      normal: CsdButtonStateStyle.fromJson(json["normal"], base: json),
      hover: CsdButtonStateStyle.fromJson(json["hover"], base: json),
      pressed: CsdButtonStateStyle.fromJson(json["pressed"], base: json)
    );
  }
}

class CsdTheme {
  final String? name;
  final String? author;
  final CsdButtonStyle close;
  final CsdButtonStyle minimize;
  final CsdButtonStyle maximize;
  final CsdButtonStyle restore;

  const CsdTheme({
    this.name,
    this.author,
    required this.close,
    required this.minimize,
    required this.maximize,
    required this.restore,
  });

  factory CsdTheme.fromJson(Map<String, dynamic> json) {
    return CsdTheme(
      name: json["name"],
      author: json["author"],
      close: CsdButtonStyle.fromJson(json["close"]),
      minimize: CsdButtonStyle.fromJson(json["minimize"]),
      maximize: CsdButtonStyle.fromJson(json["maximize"]),
      restore: CsdButtonStyle.fromJson(json["restore"]),
    );
  }
}
