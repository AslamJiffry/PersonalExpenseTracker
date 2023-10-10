import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/database_provider.dart';
//screens
import './screens/home_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: const PersonalExpenceTracker(),
  ));
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
