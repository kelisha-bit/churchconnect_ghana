import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/calendar_view.dart';
import './widgets/empty_events_state.dart';
import './widgets/event_card.dart';
import './widgets/event_filter_chips.dart';
import './widgets/event_search_bar.dart';
import './widgets/loading_skeleton.dart';

class ChurchEventsScreen extends StatefulWidget {
  const ChurchEventsScreen({super.key});

  @override
  State<ChurchEventsScreen> createState() => _ChurchEventsScreenState();
}

class _ChurchEventsScreenState extends State<ChurchEventsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 1; // Events tab active
  String _selectedFilter = 'All';
  String _searchQuery = '';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _allEvents = [];
  List<Map<String, dynamic>> _filteredEvents = [];

  // Mock events data
  final List<Map<String, dynamic>> _mockEvents = [
    {
      "id": 1,
      "title": "Sunday Morning Worship Service",
      "description":
          "Join us for our weekly worship service with inspiring messages and uplifting music.",
      "date": "2025-08-03T09:00:00",
      "location": "Main Sanctuary, Greater Works City Church",
      "category": "Services",
      "imageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop",
      "attendanceCount": 245,
      "userRsvpStatus": "Going",
      "isLive": false,
      "isPaid": false,
      "price": null,
    },
    {
      "id": 2,
      "title": "Youth Fellowship Night",
      "description":
          "An evening of fellowship, games, and spiritual growth for young adults aged 18-35.",
      "date": "2025-08-05T18:30:00",
      "location": "Youth Hall, Greater Works City Church",
      "category": "Youth",
      "imageUrl":
          "https://images.pexels.com/photos/1157557/pexels-photo-1157557.jpeg?w=800&h=400&fit=crop",
      "attendanceCount": 67,
      "userRsvpStatus": "Maybe",
      "isLive": false,
      "isPaid": false,
      "price": null,
    },
    {
      "id": 3,
      "title": "Community Outreach Program",
      "description":
          "Join us as we serve our community by providing meals and support to those in need.",
      "date": "2025-08-07T14:00:00",
      "location": "Accra Central Market Area",
      "category": "Outreach",
      "imageUrl":
          "https://images.pixabay.com/photo/2017/05/15/23/40/charity-2314471_1280.jpg?w=800&h=400&fit=crop",
      "attendanceCount": 32,
      "userRsvpStatus": null,
      "isLive": false,
      "isPaid": false,
      "price": null,
    },
    {
      "id": 4,
      "title": "Wednesday Bible Study",
      "description":
          "Deep dive into God's word with interactive discussions and practical applications.",
      "date": "2025-08-06T19:00:00",
      "location": "Conference Room A, Greater Works City Church",
      "category": "Meetings",
      "imageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop",
      "attendanceCount": 28,
      "userRsvpStatus": "Going",
      "isLive": false,
      "isPaid": false,
      "price": null,
    },
    {
      "id": 5,
      "title": "Live Prayer Meeting",
      "description":
          "Join us for a powerful time of prayer and intercession for our community and nation.",
      "date": "2025-08-02T21:45:00",
      "location": "Main Sanctuary, Greater Works City Church",
      "category": "Services",
      "imageUrl":
          "https://images.pexels.com/photos/8468/pray-hands-praying-prayer.jpg?w=800&h=400&fit=crop",
      "attendanceCount": 89,
      "userRsvpStatus": "Going",
      "isLive": true,
      "isPaid": false,
      "price": null,
    },
    {
      "id": 6,
      "title": "Church Leadership Conference",
      "description":
          "Annual conference for church leaders and ministry heads to discuss vision and strategy.",
      "date": "2025-07-28T09:00:00",
      "location": "Conference Center, Greater Works City Church",
      "category": "Meetings",
      "imageUrl":
          "https://images.pixabay.com/photo/2016/11/23/15/48/audience-1853662_1280.jpg?w=800&h=400&fit=crop",
      "attendanceCount": 156,
      "userRsvpStatus": "Going",
      "isLive": false,
      "isPaid": false,
      "price": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _allEvents = List.from(_mockEvents);
      _filteredEvents = List.from(_allEvents);
      _isLoading = false;
    });

    _applyFilters();
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _allEvents = List.from(_mockEvents);
      _isRefreshing = false;
    });

    _applyFilters();
    HapticFeedback.lightImpact();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allEvents);

    // Apply category filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((event) => (event['category'] as String) == _selectedFilter)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        final title = (event['title'] as String).toLowerCase();
        final description = (event['description'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Sort events by date
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['date'] as String);
      final dateB = DateTime.parse(b['date'] as String);
      return dateA.compareTo(dateB);
    });

    setState(() {
      _filteredEvents = filtered;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _applyFilters();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onRsvpChanged(String eventId, String rsvpStatus) {
    final eventIndex =
        _allEvents.indexWhere((event) => event['id'].toString() == eventId);

    if (eventIndex != -1) {
      setState(() {
        _allEvents[eventIndex]['userRsvpStatus'] =
            rsvpStatus == 'none' ? null : rsvpStatus;

        // Update attendance count based on RSVP
        if (rsvpStatus == 'Going') {
          _allEvents[eventIndex]['attendanceCount'] =
              (_allEvents[eventIndex]['attendanceCount'] as int) + 1;
        } else if (rsvpStatus == 'none') {
          _allEvents[eventIndex]['attendanceCount'] =
              (_allEvents[eventIndex]['attendanceCount'] as int) - 1;
        }
      });
      _applyFilters();
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onEventTap(Map<String, dynamic> event) {
    HapticFeedback.lightImpact();
    // Navigate to event details screen
    // Navigator.pushNamed(context, '/event-details-screen', arguments: event);

    // Show event details in bottom sheet for now
    _showEventDetailsBottomSheet(event);
  }

  void _showEventDetailsBottomSheet(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),

            // Event details content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CustomImageWidget(
                        imageUrl: event['imageUrl'] as String,
                        width: double.infinity,
                        height: 25.h,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Event title
                    Text(
                      event['title'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Event description
                    Text(
                      event['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Event details
                    _buildEventDetailRow(
                        'Date & Time',
                        DateFormat('EEEE, dd MMMM yyyy • HH:mm')
                            .format(DateTime.parse(event['date'] as String))),
                    _buildEventDetailRow(
                        'Location', event['location'] as String),
                    _buildEventDetailRow(
                        'Category', event['category'] as String),
                    _buildEventDetailRow('Expected Attendance',
                        '${event['attendanceCount']} people'),

                    SizedBox(height: 4.h),

                    // Share button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _shareEvent(event);
                        },
                        icon: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        label: Text('Share Event'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _shareEvent(Map<String, dynamic> event) {
    final eventDate = DateTime.parse(event['date'] as String);
    final shareText = '''
🙏 ${event['title']}

📅 ${DateFormat('EEEE, dd MMMM yyyy').format(eventDate)}
⏰ ${DateFormat('HH:mm').format(eventDate)}
📍 ${event['location']}

${event['description']}

Join us at Greater Works City Church! 
#ChurchConnect #GreaterWorksGhana
    ''';

    // In a real app, you would use share_plus package
    // Share.share(shareText);

    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event details copied for sharing'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _createEvent() {
    HapticFeedback.lightImpact();
    // Navigate to create event screen
    // Navigator.pushNamed(context, '/create-event-screen');

    // Show create event dialog for now
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Event'),
        content: Text(
            'Event creation feature will be available soon for authorized members.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.secondary(
        title: 'Church Events',
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Show sync status or settings
            },
            icon: CustomIconWidget(
              iconName: _isRefreshing ? 'sync' : 'sync',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Sync Events',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'view_list',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text('List'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_month',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text('Calendar'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          EventSearchBar(
            searchQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onClearSearch: () {
              setState(() {
                _searchQuery = '';
              });
              _applyFilters();
            },
          ),

          // Filter Chips
          EventFilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // List View
                _isLoading
                    ? LoadingSkeleton()
                    : RefreshIndicator(
                        onRefresh: _refreshEvents,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        child: _filteredEvents.isEmpty
                            ? EmptyEventsState(
                                message: _searchQuery.isNotEmpty
                                    ? 'No events found matching "$_searchQuery". Try adjusting your search terms.'
                                    : _selectedFilter != 'All'
                                        ? 'No $_selectedFilter events found. Check other categories or create a new event.'
                                        : 'No upcoming events scheduled. Stay tuned for exciting church activities!',
                                actionText: 'Refresh Events',
                                onActionPressed: _refreshEvents,
                                showCreateEventButton: true,
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                itemCount: _filteredEvents.length,
                                itemBuilder: (context, index) {
                                  final event = _filteredEvents[index];
                                  return EventCard(
                                    event: event,
                                    onRsvpChanged: _onRsvpChanged,
                                    onTap: () => _onEventTap(event),
                                  );
                                },
                              ),
                      ),

                // Calendar View
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      )
                    : CalendarView(
                        events: _allEvents,
                        onDateSelected: _onDateSelected,
                        selectedDate: _selectedDate,
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEvent,
        tooltip: 'Create Event',
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 24,
        ),
      ),
      bottomNavigationBar: CustomBottomBar.main(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
      ),
    );
  }
}
