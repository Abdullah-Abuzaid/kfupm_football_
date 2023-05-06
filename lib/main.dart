import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'menu/side_menu_wrapper.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ogppvkxbdszmzfvhithj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ncHB2a3hiZHN6bXpmdmhpdGhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODIzNjI5MzUsImV4cCI6MTk5NzkzODkzNX0.0LoyhXJwnDdZ7BELjaVlu_3J2UeVGfjJ8CXb7LZyjJI',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K')
          ],
        ),
        home: MenuWrapper(),
      ),
    );
  }
}
