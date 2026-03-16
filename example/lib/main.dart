import 'dart:convert';

import 'package:example/edit_button_style.dart';
import 'package:example/theme_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linux_csd_buttons/linux_csd_buttons.dart';
import 'package:window_manager/window_manager.dart';

import 'mutable_csd_theme.dart';
final mainScreenKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeData = jsonDecode(await rootBundle.loadString("assets/example.json"));
  themeState.theme = MutableCsdTheme.fromJson(themeData);
  runApp(MyApp(key: mainScreenKey));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var isLightMode = true;

  @override
  Widget build(BuildContext context) {
    final csdTheme = themeState.theme.toTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
            bodyLarge: TextStyle(
                color: Colors.black
            ),
            bodyMedium: TextStyle(
                color: Colors.black
            )
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromARGB(255, 25, 25, 25),
        textTheme: TextTheme(
            bodyLarge: TextStyle(
                color: Colors.white
            ),
          bodyMedium: TextStyle(
            color: Colors.white
          )
        ),
        primaryTextTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.white
          )
        ),
      ),
      themeMode: isLightMode ? ThemeMode.light : ThemeMode.dark,
      home: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Text("Theme Generator", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
              Positioned(
                  right: 0,
                  top: 0,
                  child: SizedBox(
                    width: 200,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CsdButton(theme: csdTheme, type: CsdButtonType.minimize, onPressed: () {

                          }),
                          MaximizeOrRestoreButton(csdThemeData: csdTheme),
                          CsdButton(theme: csdTheme, type: CsdButtonType.close, onPressed: () {

                          }),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(value: isLightMode, onChanged: (value) {
                          setState(() {
                            isLightMode = value;
                          });
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CsdButton(theme: csdTheme, type: CsdButtonType.minimize, onPressed: () {}),
                        CsdButton(theme: csdTheme, type: CsdButtonType.restore, onPressed: () {}),
                        CsdButton(theme: csdTheme, type: CsdButtonType.maximize, onPressed: () {}),
                        CsdButton(theme: csdTheme, type: CsdButtonType.close, onPressed: () {}),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Expanded(child: EditButtonStyle(type: CsdButtonType.minimize)),
                            Expanded(child: EditButtonStyle(type: CsdButtonType.restore)),
                            Expanded(child: EditButtonStyle(type: CsdButtonType.maximize)),
                            Expanded(child: EditButtonStyle(type: CsdButtonType.close))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["json"], allowMultiple: false);
                            final xFile = result?.files.firstOrNull?.xFile;
                            if(xFile != null) {
                              final iconData = await xFile.readAsString();
                              setState(() {
                                themeState.theme = MutableCsdTheme.fromJson(jsonDecode(iconData));
                              });
                            }
                          }, child: Text("Import")),
                          Builder(
                            builder: (context) {
                              return TextButton(
                                onPressed: () {
                                  final encoder = const JsonEncoder.withIndent('  ');
                                  final String themeJson = encoder.convert(themeState.theme.toJson());

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Export Theme"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Copy the configuration below:",
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 12),

                                            Container(
                                              width: double.maxFinite,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Theme.of(context).dividerColor),
                                              ),
                                              constraints: const BoxConstraints(maxHeight: 300),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: SingleChildScrollView(
                                                  padding: const EdgeInsets.all(16),
                                                  child: SelectableText(
                                                    themeJson,
                                                    style: const TextStyle(
                                                      fontFamily: 'monospace',
                                                      fontSize: 13,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("Close"),
                                          ),
                                          FilledButton.icon(
                                            icon: const Icon(Icons.content_copy_rounded, size: 18),
                                            label: const Text("Copy to Clipboard"),
                                            onPressed: () async {
                                              await Clipboard.setData(ClipboardData(text: themeJson));

                                              if (context.mounted) {
                                                Navigator.pop(context);

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text("Theme JSON copied to clipboard!"),
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    width: 300,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text("Export"),
                              );
                            }
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}

class Line extends StatelessWidget {

  final String title;
  final Widget widget;
  final void Function() onEditButtonPressed;

  const Line({super.key, required this.title, required this.widget, required this.onEditButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title),
      widget,
      IconButton(onPressed: () {
        onEditButtonPressed();
      }, icon: Icon(Icons.edit))
    ]);
  }
}

class MaximizeOrRestoreButton extends StatefulWidget {

  final CsdTheme csdThemeData;

  const MaximizeOrRestoreButton({super.key, required this.csdThemeData});

  @override
  State<MaximizeOrRestoreButton> createState() => _MaximizeOrRestoreButtonState();
}

class _MaximizeOrRestoreButtonState extends State<MaximizeOrRestoreButton> with WindowListener {

  CsdButtonType buttonType = CsdButtonType.maximize;

  @override
  void onWindowMaximize() {
    setState(() {
      buttonType = CsdButtonType.restore;
    });
  }

  @override
  void onWindowRestore() {
    setState(() {
      buttonType = CsdButtonType.maximize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CsdButton(theme: widget.csdThemeData, type: buttonType, onPressed: () {

    });
  }
}
