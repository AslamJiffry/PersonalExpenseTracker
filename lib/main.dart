import 'package:flutter/material.dart';
//screens
import './screens/home_screen.dart';

void main() {
  runApp(const PersonalExpenceTracker());
}

class PersonalExpenceTracker extends StatelessWidget {
  const PersonalExpenceTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.name,
      routes: {
        HomeScreen.name: (_) => const HomeScreen(),
      },
    );
  }
}
