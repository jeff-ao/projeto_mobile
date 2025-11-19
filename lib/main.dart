import 'package:flutter/cupertino.dart';
import 'screens/translator_screen.dart';

// ValueNotifier global para controlar o tema
final ValueNotifier<Brightness> themeNotifier = ValueNotifier(Brightness.dark);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: themeNotifier,
      builder: (context, brightness, child) {
        return CupertinoApp(
          title: 'Tradutor 3000',
          theme: CupertinoThemeData(
            brightness: brightness,
            primaryColor: CupertinoColors.activeBlue,
          ),
          debugShowCheckedModeBanner: false,
          home: const TranslatorScreen(),
        );
      },
    );
  }
}
