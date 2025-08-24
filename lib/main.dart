import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:patient_tracker_flutter/providers/patient_provider.dart';
import 'package:patient_tracker_flutter/providers/assessment_scales_provider.dart';
import 'package:patient_tracker_flutter/screens/dashboard_screen.dart';
import 'package:patient_tracker_flutter/utils/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database only on mobile/desktop platforms
  // Skip database initialization on web to avoid SQLite issues
  try {
    await DatabaseHelper().database;
  } catch (e) {
    print('Database initialization skipped for web platform: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => AssessmentScalesProvider()),
      ],
      child: MaterialApp(
        title: 'Patient Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
