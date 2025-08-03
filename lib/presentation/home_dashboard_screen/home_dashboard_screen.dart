import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/church_data_widget.dart';
import '../../services/auth_service.dart';
import './widgets/church_greeting_header_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/upcoming_service_card_widget.dart';
import './widgets/recent_sermon_card_widget.dart';
import './widgets/devotional_card_widget.dart';
import './widgets/church_announcements_widget.dart';
import './widgets/upcoming_birthdays_widget.dart';
import './widgets/live_service_indicator_widget.dart';
import './widgets/weather_widget.dart';
import './widgets/inspirational_quote_widget.dart';
import './widgets/church_contact_widget.dart';
import './widgets/church_photos_widget.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final AuthService _authService = AuthService.instance;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: const CustomAppBar(title: "Home", centerTitle: false),
        body: ChurchDataWidget(builder: (context, data, isLoading) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),

                        // Church Greeting Header with real data
                        ChurchGreetingHeaderWidget(
                          currentDate: DateTime.now(),
                          memberName: "Welcome",
                        ),

                        SizedBox(height: 3.h),

                        // Live Service Indicator
                        LiveServiceIndicatorWidget(isLive: false),

                        SizedBox(height: 3.h),

                        // Quick Actions Grid
                        const QuickActionsGridWidget(),

                        SizedBox(height: 3.h),

                        // Upcoming Service Card with real data
                        if (data.upcomingEvents.isNotEmpty)
                          UpcomingServiceCardWidget(
                              event: data.upcomingEvents.first),

                        SizedBox(height: 3.h),

                        // Recent Sermon Card with real data
                        if (data.recentSermons.isNotEmpty)
                          RecentSermonCardWidget(
                              sermon: data.recentSermons.first),

                        SizedBox(height: 3.h),

                        // Devotional Card
                        DevotionalCardWidget(devotionalData: {}),

                        SizedBox(height: 3.h),

                        // Church Announcements with real events
                        ChurchAnnouncementsWidget(
                            events: data.upcomingEvents.take(3).toList()),

                        SizedBox(height: 3.h),

                        // Upcoming Birthdays with real data
                        UpcomingBirthdaysWidget(
                            members: data.birthdayMembers.take(5).toList()),

                        SizedBox(height: 3.h),

                        // Weather Widget
                        WeatherWidget(weatherData: {}),

                        SizedBox(height: 3.h),

                        // Inspirational Quote
                        InspirationalQuoteWidget(quoteData: {}),

                        SizedBox(height: 3.h),

                        // Church Contact
                        ChurchContactWidget(contactData: {}),

                        SizedBox(height: 3.h),

                        // Church Photos
                        ChurchPhotosWidget(photos: []),

                        SizedBox(height: 10.h),
                      ])));
        }),
        bottomNavigationBar: CustomBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ));
  }
}