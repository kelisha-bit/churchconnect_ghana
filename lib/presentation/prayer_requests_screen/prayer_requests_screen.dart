import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_prayer_state.dart';
import './widgets/new_prayer_request_form.dart';
import './widgets/prayer_filter_tabs.dart';
import './widgets/prayer_request_card.dart';

class PrayerRequestsScreen extends StatefulWidget {
  const PrayerRequestsScreen({super.key});

  @override
  State<PrayerRequestsScreen> createState() => _PrayerRequestsScreenState();
}

class _PrayerRequestsScreenState extends State<PrayerRequestsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 3; // Prayer tab index
  int _selectedFilterIndex = 0;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _searchQuery = '';

  final List<String> _filterTabs = [
    'All',
    'My Requests',
    'Praying For',
    'Answered'
  ];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allPrayerRequests = [];
  List<Map<String, dynamic>> _filteredRequests = [];
  Set<int> _prayedForRequests = {};

  // Mock current user data
  final String _currentUserId = 'user_123';
  final String _currentUserName = 'Sarah Johnson';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filterTabs.length, vsync: this);
    _loadMockData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    // Mock prayer requests data
    _allPrayerRequests = [
      {
        'id': 1,
        'userId': 'user_456',
        'memberName': 'Michael Asante',
        'title': 'Healing for My Mother',
        'description':
            'Please pray for my mother who is in the hospital recovering from surgery. The doctors say she is doing well, but I would appreciate prayers for her complete healing and strength during this time. She has been such a pillar of faith in our family, and I know God has great plans for her continued health.',
        'category': 'Health',
        'privacyLevel': 'Public',
        'isAnonymous': false,
        'timestamp': DateTime.now().subtract(Duration(hours: 2)),
        'prayerCount': 15,
        'isAnswered': false,
      },
      {
        'id': 2,
        'userId': _currentUserId,
        'memberName': _currentUserName,
        'title': 'Job Interview Success',
        'description':
            'I have an important job interview next week for a position that would really help my family financially. Please pray that God\'s will be done and that if this is the right opportunity, the doors will open. I\'ve been preparing diligently and trust in His perfect timing.',
        'category': 'Work',
        'privacyLevel': 'Public',
        'isAnonymous': false,
        'timestamp': DateTime.now().subtract(Duration(hours: 5)),
        'prayerCount': 8,
        'isAnswered': false,
      },
      {
        'id': 3,
        'userId': 'user_789',
        'memberName': 'Anonymous',
        'title': '',
        'description':
            'Please pray for restoration in my marriage. We are going through a difficult time and I believe that with God\'s help and the prayers of the church family, we can work through these challenges. I know that God hates divorce and wants families to stay together.',
        'category': 'Family',
        'privacyLevel': 'Small Group Only',
        'isAnonymous': true,
        'timestamp': DateTime.now().subtract(Duration(days: 1)),
        'prayerCount': 23,
        'isAnswered': false,
      },
      {
        'id': 4,
        'userId': 'user_101',
        'memberName': 'Grace Mensah',
        'title': 'Praise Report - New Job!',
        'description':
            'Thank you all for praying for my job search! I am excited to share that I received a job offer yesterday for a position that is even better than what I was hoping for. God truly knows what is best for us. Your prayers and support meant so much to me during this season of waiting.',
        'category': 'Work',
        'privacyLevel': 'Public',
        'isAnonymous': false,
        'timestamp': DateTime.now().subtract(Duration(days: 2)),
        'prayerCount': 31,
        'isAnswered': true,
      },
      {
        'id': 5,
        'userId': 'user_202',
        'memberName': 'Emmanuel Osei',
        'title': 'Wisdom for Ministry Decision',
        'description':
            'I am seeking God\'s direction regarding a ministry opportunity that has been presented to me. Please pray for wisdom and discernment as I consider whether this is where God is calling me to serve. I want to be faithful to His leading and make sure I am following His will, not my own desires.',
        'category': 'Spiritual',
        'privacyLevel': 'Pastoral Team Only',
        'isAnonymous': false,
        'timestamp': DateTime.now().subtract(Duration(days: 3)),
        'prayerCount': 12,
        'isAnswered': false,
      },
      {
        'id': 6,
        'userId': 'user_303',
        'memberName': 'Abena Kwarteng',
        'title': 'Financial Breakthrough',
        'description':
            'Our family is facing some financial challenges this month with unexpected medical bills. Please pray for God\'s provision and for wisdom in managing our resources. We trust that He will provide for all our needs according to His riches in glory, and we are grateful for this church family.',
        'category': 'Financial',
        'privacyLevel': 'Public',
        'isAnonymous': false,
        'timestamp': DateTime.now().subtract(Duration(days: 4)),
        'prayerCount': 19,
        'isAnswered': false,
      },
    ];

    // Mock prayed for requests
    _prayedForRequests = {1, 3, 4, 6};

    setState(() {
      _isLoading = false;
      _filterRequests();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more data if needed
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    // Simulate loading more data
    // In a real app, this would fetch more requests from the API
  }

  void _filterRequests() {
    List<Map<String, dynamic>> filtered = List.from(_allPrayerRequests);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((request) {
        final title = (request['title'] as String? ?? '').toLowerCase();
        final description =
            (request['description'] as String? ?? '').toLowerCase();
        final memberName =
            (request['memberName'] as String? ?? '').toLowerCase();
        final category = (request['category'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            memberName.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply tab filter
    switch (_selectedFilterIndex) {
      case 1: // My Requests
        filtered = filtered
            .where((request) => request['userId'] == _currentUserId)
            .toList();
        break;
      case 2: // Praying For
        filtered = filtered
            .where((request) => _prayedForRequests.contains(request['id']))
            .toList();
        break;
      case 3: // Answered
        filtered =
            filtered.where((request) => request['isAnswered'] == true).toList();
        break;
      default: // All
        break;
    }

    // Sort by timestamp (newest first)
    filtered.sort((a, b) {
      final aTime = a['timestamp'] as DateTime;
      final bTime = b['timestamp'] as DateTime;
      return bTime.compareTo(aTime);
    });

    setState(() {
      _filteredRequests = filtered;
    });
  }

  Map<String, int> _getTabCounts() {
    return {
      'All': _allPrayerRequests.length,
      'My Requests':
          _allPrayerRequests.where((r) => r['userId'] == _currentUserId).length,
      'Praying For': _prayedForRequests.length,
      'Answered':
          _allPrayerRequests.where((r) => r['isAnswered'] == true).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar.secondary(
        title: 'Prayer Requests',
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: CustomIconWidget(
              iconName: 'search',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Search prayers',
          ),
          IconButton(
            onPressed: _showNotificationSettings,
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Notification settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.primaryColor,
        child: Column(
          children: [
            // Filter Tabs
            PrayerFilterTabs(
              tabs: _filterTabs,
              selectedIndex: _selectedFilterIndex,
              onTabSelected: _onFilterTabSelected,
              tabCounts: _getTabCounts(),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredRequests.isEmpty
                      ? _buildEmptyState()
                      : _buildRequestsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewRequestForm,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.black,
          size: 24,
        ),
        label: Text(
          'New Request',
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
      bottomNavigationBar: CustomBottomBar.main(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 5,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.w),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 2.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 1.5.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 1.5.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            height: 1.5.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyPrayerState(
      filterType: _filterTabs[_selectedFilterIndex],
      onCreateRequest: _showNewRequestForm,
    );
  }

  Widget _buildRequestsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: 1.h,
        bottom: 10.h, // Space for FAB
      ),
      itemCount: _filteredRequests.length,
      itemBuilder: (context, index) {
        final request = _filteredRequests[index];
        final isOwnRequest = request['userId'] == _currentUserId;

        return PrayerRequestCard(
          request: request,
          onTap: () => _showRequestDetails(request),
          onPrayTap: () => _handlePrayForRequest(request),
          onEdit: isOwnRequest ? () => _editRequest(request) : null,
          onDelete: isOwnRequest ? () => _deleteRequest(request) : null,
          showActions: isOwnRequest,
        );
      },
    );
  }

  void _onFilterTabSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
      _filterRequests();
    });
    HapticFeedback.lightImpact();
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API refresh
    await Future.delayed(Duration(seconds: 1));

    _loadMockData();

    setState(() => _isRefreshing = false);
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Prayer Requests'),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by title, description, or member...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: CustomIconWidget(
                iconName: 'search',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                size: 20,
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _filterRequests();
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _filterRequests();
              });
              Navigator.pop(context);
            },
            child: Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Prayer Notifications',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 2.h),
                SwitchListTile(
                  title: Text('New Prayer Requests'),
                  subtitle:
                      Text('Get notified when someone shares a new request'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: Text('Prayer Responses'),
                  subtitle:
                      Text('Get notified when someone prays for your requests'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: Text('Answered Prayers'),
                  subtitle:
                      Text('Get notified when prayers are marked as answered'),
                  value: true,
                  onChanged: (value) {},
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNewRequestForm() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NewPrayerRequestForm(
        onSubmit: _handleNewRequest,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _handleNewRequest(Map<String, dynamic> request) {
    setState(() {
      _allPrayerRequests.insert(0, request);
      _filterRequests();
    });
    Navigator.pop(context);
    HapticFeedback.mediumImpact();
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildRequestDetailsModal(request),
    );
  }

  Widget _buildRequestDetailsModal(Map<String, dynamic> request) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAnonymous = request['isAnonymous'] as bool? ?? false;
    final memberName = request['memberName'] as String? ?? 'Anonymous';
    final title = request['title'] as String? ?? '';
    final description = request['description'] as String? ?? '';
    final category = request['category'] as String? ?? 'General';
    final prayerCount = request['prayerCount'] as int? ?? 0;
    final isAnswered = request['isAnswered'] as bool? ?? false;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Prayer Request Details',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Member info
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: isAnonymous
                              ? colorScheme.outline.withValues(alpha: 0.2)
                              : AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Center(
                          child: Text(
                            isAnonymous
                                ? '?'
                                : memberName
                                    .split(' ')
                                    .map((e) => e[0])
                                    .take(2)
                                    .join(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isAnonymous
                                  ? colorScheme.onSurface.withValues(alpha: 0.6)
                                  : AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAnonymous ? 'Anonymous Request' : memberName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    category,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isAnswered) ...[
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'check_circle',
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          'Answered',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Title
                  if (title.isNotEmpty) ...[
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Description
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Prayer count
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'favorite',
                          color: Colors.red.withValues(alpha: 0.7),
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '$prayerCount ${prayerCount == 1 ? 'person has' : 'people have'} prayed for this request',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handlePrayForRequest(request);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'favorite',
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Pray for This Request',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePrayForRequest(Map<String, dynamic> request) {
    final requestId = request['id'] as int;

    setState(() {
      if (_prayedForRequests.contains(requestId)) {
        _prayedForRequests.remove(requestId);
        request['prayerCount'] = (request['prayerCount'] as int) - 1;
      } else {
        _prayedForRequests.add(requestId);
        request['prayerCount'] = (request['prayerCount'] as int) + 1;
      }
      _filterRequests();
    });

    HapticFeedback.mediumImpact();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'favorite',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(_prayedForRequests.contains(requestId)
                ? 'Added to your prayer list'
                : 'Removed from your prayer list'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _editRequest(Map<String, dynamic> request) {
    // In a real app, this would open an edit form
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit functionality would be implemented here'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Prayer Request'),
        content: Text(
            'Are you sure you want to delete this prayer request? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allPrayerRequests.removeWhere((r) => r['id'] == request['id']);
                _filterRequests();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Prayer request deleted'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
