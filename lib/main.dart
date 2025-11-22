import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';      
import 'screens/home_screen.dart';
import 'screens/simulator/simulator_screen.dart';
import 'screens/info/who_can_donate_screen.dart';
import 'screens/info/post_care_screen.dart';
import 'screens/hemocenters/hemocenter_search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BloodDonationApp());
}

class BloodDonationApp extends StatelessWidget {
  const BloodDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donation',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const WelcomeScreen(),         
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        SimulatorScreen.route: (_) => const SimulatorScreen(),
        WhoCanDonateScreen.route: (_) => const WhoCanDonateScreen(),
        PostCareScreen.route: (_) => const PostCareScreen(),
        HemocenterSearchScreen.route: (_) => const HemocenterSearchScreen(),
      },
    );
  }
}
