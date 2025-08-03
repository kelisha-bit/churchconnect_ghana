import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../models/member_model.dart';
import '../models/event_model.dart';
import '../models/prayer_request_model.dart';
import '../models/donation_model.dart';
import '../models/sermon_model.dart';
import '../services/member_service.dart';
import '../services/event_service.dart';
import '../services/prayer_service.dart';
import '../services/donation_service.dart';
import '../services/sermon_service.dart';
import '../utils/date_utils.dart';

class ChurchDataWidget extends StatefulWidget {
  final Widget Function(BuildContext context, ChurchData data, bool isLoading)
      builder;

  const ChurchDataWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _ChurchDataWidgetState createState() => _ChurchDataWidgetState();
}

class _ChurchDataWidgetState extends State<ChurchDataWidget> {
  final MemberService _memberService = MemberService.instance;
  final EventService _eventService = EventService.instance;
  final PrayerService _prayerService = PrayerService.instance;
  final DonationService _donationService = DonationService.instance;
  final SermonService _sermonService = SermonService.instance;

  ChurchData _data = ChurchData();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChurchData();
  }

  Future<void> _loadChurchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load data in parallel for better performance
      final futures = await Future.wait([
        _memberService.getAllMembers(),
        _eventService.getUpcomingEvents(limit: 5),
        _prayerService.getRecentPrayerRequests(limit: 5),
        _donationService.getRecentDonations(limit: 5),
        _sermonService.getRecentSermons(limit: 3),
        _memberService.getMemberStatistics(),
        _eventService.getEventStatistics(),
        _donationService.getDonationStatistics(),
      ]);

      setState(() {
        _data = ChurchData(
          members: futures[0] as List<MemberModel>,
          upcomingEvents: futures[1] as List<EventModel>,
          recentPrayerRequests: futures[2] as List<PrayerRequestModel>,
          recentDonations: futures[3] as List<DonationModel>,
          recentSermons: futures[4] as List<SermonModel>,
          memberStats: futures[5] as Map<String, dynamic>,
          eventStats: futures[6] as Map<String, dynamic>,
          donationStats: futures[7] as Map<String, dynamic>,
        );
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error silently or show error widget
      print('Error loading church data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _data, _isLoading);
  }
}

class ChurchData {
  final List<MemberModel> members;
  final List<EventModel> upcomingEvents;
  final List<PrayerRequestModel> recentPrayerRequests;
  final List<DonationModel> recentDonations;
  final List<SermonModel> recentSermons;
  final Map<String, dynamic> memberStats;
  final Map<String, dynamic> eventStats;
  final Map<String, dynamic> donationStats;

  ChurchData({
    this.members = const [],
    this.upcomingEvents = const [],
    this.recentPrayerRequests = const [],
    this.recentDonations = const [],
    this.recentSermons = const [],
    this.memberStats = const {},
    this.eventStats = const {},
    this.donationStats = const {},
  });

  // Helper getters
  int get totalMembers => memberStats['total_members'] ?? 0;
  int get activeMembers => memberStats['active_members'] ?? 0;
  int get newMembersThisMonth => memberStats['new_this_month'] ?? 0;

  int get totalEvents => eventStats['total_events'] ?? 0;
  int get upcomingEventsCount => eventStats['upcoming_events'] ?? 0;
  int get eventsThisMonth => eventStats['this_month_events'] ?? 0;

  double get totalDonations => (donationStats['total_amount'] ?? 0).toDouble();
  double get donationsThisMonth =>
      (donationStats['this_month_amount'] ?? 0).toDouble();
  int get totalDonationCount => donationStats['total_donations'] ?? 0;

  List<MemberModel> get birthdayMembers {
    final currentMonth = DateTime.now().month;
    return members
        .where((member) =>
            member.dateOfBirth != null &&
            member.dateOfBirth!.month == currentMonth)
        .toList();
  }

  List<EventModel> get todayEvents {
    return upcomingEvents.where((event) => event.isToday).toList();
  }

  List<EventModel> get thisWeekEvents {
    final now = DateTime.now();
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));
    return upcomingEvents
        .where((event) =>
            event.eventDate.isBefore(endOfWeek) &&
            event.eventDate.isAfter(now.subtract(const Duration(days: 1))))
        .toList();
  }

  bool get hasData => members.isNotEmpty || upcomingEvents.isNotEmpty;
}

// Convenience widgets for common data displays
class MemberCountWidget extends StatelessWidget {
  final ChurchData data;
  final bool showDetails;

  const MemberCountWidget({
    Key? key,
    required this.data,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Members',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '${data.totalMembers}',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          if (showDetails) ...[
            SizedBox(height: 1.h),
            Text(
              'Active: ${data.activeMembers}',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: Colors.blue.shade700,
              ),
            ),
            Text(
              'New this month: ${data.newMembersThisMonth}',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class NextEventWidget extends StatelessWidget {
  final ChurchData data;

  const NextEventWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.upcomingEvents.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Text(
          'No upcoming events',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    final nextEvent = data.upcomingEvents.first;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Event',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade800,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            nextEvent.title,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            AppDateUtils.getRelativeDateString(nextEvent.eventDate),
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
