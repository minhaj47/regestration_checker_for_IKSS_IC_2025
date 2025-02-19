import 'package:flutter/material.dart';
import 'package:registration_checker/google_sheets_api.dart';
import 'package:registration_checker/qr_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSheetsApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        useMaterial3: true,
      ),
      home: const QrScanner(),
    );
  }
}
