import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'screens/pdf_viewer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Pdf View',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            useSystemColors: true,
            brightness: Brightness.light,
            colorScheme: lightDynamic,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            useSystemColors: true,
            brightness: Brightness.dark,
            colorScheme: darkDynamic,
          ),
          themeMode: ThemeMode.system,
          home: PdfViewerScreen(),
        );
      },
    );
  }
}
