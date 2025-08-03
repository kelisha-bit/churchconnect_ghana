import 'package:flutter/material.dart';
import '../presentation/church_events_screen/church_events_screen.dart';
import '../presentation/member_directory_screen/member_directory_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/prayer_requests_screen/prayer_requests_screen.dart';
import '../presentation/home_dashboard_screen/home_dashboard_screen.dart';
import '../presentation/give_and_tithe_screen/give_and_tithe_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String churchEvents = '/church-events-screen';
  static const String memberDirectory = '/member-directory-screen';
  static const String login = '/login-screen';
  static const String prayerRequests = '/prayer-requests-screen';
  static const String homeDashboard = '/home-dashboard-screen';
  static const String giveAndTithe = '/give-and-tithe-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    churchEvents: (context) => const ChurchEventsScreen(),
    memberDirectory: (context) => const MemberDirectoryScreen(),
    login: (context) => const LoginScreen(),
    prayerRequests: (context) => const PrayerRequestsScreen(),
    homeDashboard: (context) => const HomeDashboardScreen(),
    giveAndTithe: (context) => const GiveAndTitheScreen(),
    // TODO: Add your other routes here
  };
}
