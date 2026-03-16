import 'package:example/mutable_csd_theme.dart';

final themeState = ThemeState.getInstance();

class ThemeState {
  late MutableCsdTheme theme;

  static final ThemeState _instance = ThemeState();
  static ThemeState getInstance() => _instance;
}