import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/page_login.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zoiwwnsifxrzpeqcxbsl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvaXd3bnNpZnhyenBlcWN4YnNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4NDQxMjQsImV4cCI6MjA5MDQyMDEyNH0.HfQloZnm1XiWHVJPOVV3CDAYQed7qYmqQ7Dx5f0Sz5s',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PageLogin(),
    );
  }
}