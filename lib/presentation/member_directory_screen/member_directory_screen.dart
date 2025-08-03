import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/alphabetical_index_widget.dart';
import './widgets/member_card_widget.dart';
import './widgets/member_detail_modal_widget.dart';
import './widgets/ministry_filter_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/section_header_widget.dart';

class MemberDirectoryScreen extends StatefulWidget {
  const MemberDirectoryScreen({super.key});

  @override
  State<MemberDirectoryScreen> createState() => _MemberDirectoryScreenState();
}

class _MemberDirectoryScreenState extends State<MemberDirectoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _searchQuery = '';
  String? _selectedMinistry;
  String? _selectedLetter;
  bool _isLoading = false;
  bool _isOffline = false;
  int _currentBottomIndex = 4; // Members tab

  // Mock data for church members
  final List<Map<String, dynamic>> _allMembers = [
    {
      "id": 1,
      "name": "Kwame Asante",
      "profileImage":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Elder",
      "ministry": "Youth Ministry",
      "ministryRole": "Youth Leader",
      "phone": "+233244123456",
      "email": "kwame.asante@gmail.com",
      "location": "East Legon, Accra",
      "joinDate": "January 2018",
      "isFavorite": true,
      "isNewMember": false,
      "showPhone": true,
      "showEmail": true,
      "bio":
          "Passionate about youth development and spiritual growth. Been serving in various capacities for over 6 years.",
      "family": [
        {"name": "Akosua Asante", "relationship": "Wife"},
        {"name": "Kofi Asante", "relationship": "Son"}
      ],
      "smallGroups": [
        {"name": "Men's Fellowship", "role": "Leader"},
        {"name": "Bible Study Group A", "role": "Member"}
      ]
    },
    {
      "id": 2,
      "name": "Akosua Mensah",
      "profileImage":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Deaconess",
      "ministry": "Women's Ministry",
      "ministryRole": "Women's Leader",
      "phone": "+233201987654",
      "email": "akosua.mensah@yahoo.com",
      "location": "Tema, Greater Accra",
      "joinDate": "March 2019",
      "isFavorite": false,
      "isNewMember": false,
      "showPhone": true,
      "showEmail": false,
      "bio":
          "Dedicated to empowering women in faith and supporting church families in need.",
      "family": [
        {"name": "Yaw Mensah", "relationship": "Husband"},
        {"name": "Ama Mensah", "relationship": "Daughter"}
      ],
      "smallGroups": [
        {"name": "Women's Prayer Group", "role": "Leader"}
      ]
    },
    {
      "id": 3,
      "name": "Benjamin Osei",
      "profileImage":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Usher",
      "ministry": "Ushering Ministry",
      "ministryRole": "Head Usher",
      "phone": "+233245678901",
      "email": "ben.osei@hotmail.com",
      "location": "Madina, Accra",
      "joinDate": "June 2020",
      "isFavorite": true,
      "isNewMember": false,
      "showPhone": true,
      "showEmail": true,
      "bio":
          "Committed to creating a welcoming environment for all church members and visitors.",
      "smallGroups": [
        {"name": "Young Adults Fellowship", "role": "Member"}
      ]
    },
    {
      "id": 4,
      "name": "Comfort Adjei",
      "profileImage":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Choir Member",
      "ministry": "Music Ministry",
      "ministryRole": "Soprano",
      "phone": "+233208765432",
      "email": "comfort.adjei@gmail.com",
      "location": "Dansoman, Accra",
      "joinDate": "September 2021",
      "isFavorite": false,
      "isNewMember": true,
      "showPhone": false,
      "showEmail": true,
      "bio":
          "Passionate about worship and using music to glorify God and inspire others.",
      "family": [
        {"name": "Samuel Adjei", "relationship": "Brother"}
      ],
      "smallGroups": [
        {"name": "Choir Practice Group", "role": "Member"}
      ]
    },
    {
      "id": 5,
      "name": "Daniel Boateng",
      "profileImage":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Deacon",
      "ministry": "Finance Ministry",
      "ministryRole": "Treasurer",
      "phone": "+233234567890",
      "email": "daniel.boateng@outlook.com",
      "location": "Spintex, Accra",
      "joinDate": "November 2017",
      "isFavorite": false,
      "isNewMember": false,
      "showPhone": true,
      "showEmail": true,
      "bio":
          "Experienced in financial management and committed to transparent stewardship of church resources.",
      "smallGroups": [
        {"name": "Finance Committee", "role": "Chairman"}
      ]
    },
    {
      "id": 6,
      "name": "Esther Owusu",
      "profileImage":
          "https://images.pexels.com/photos/1181519/pexels-photo-1181519.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Sunday School Teacher",
      "ministry": "Children's Ministry",
      "ministryRole": "Children's Coordinator",
      "phone": "+233209876543",
      "email": "esther.owusu@gmail.com",
      "location": "Achimota, Accra",
      "joinDate": "February 2019",
      "isFavorite": true,
      "isNewMember": false,
      "showPhone": true,
      "showEmail": true,
      "bio":
          "Dedicated to nurturing children's spiritual growth and creating engaging learning experiences.",
      "family": [
        {"name": "Prince Owusu", "relationship": "Son"},
        {"name": "Princess Owusu", "relationship": "Daughter"}
      ],
      "smallGroups": [
        {"name": "Children's Ministry Team", "role": "Leader"}
      ]
    },
    {
      "id": 7,
      "name": "Francis Appiah",
      "profileImage":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Member",
      "ministry": "Media Ministry",
      "ministryRole": "Sound Engineer",
      "phone": "+233245123789",
      "email": "francis.appiah@yahoo.com",
      "location": "Kasoa, Central Region",
      "joinDate": "August 2022",
      "isFavorite": false,
      "isNewMember": true,
      "showPhone": true,
      "showEmail": false,
      "bio":
          "Technology enthusiast helping to enhance worship experience through quality sound and media.",
      "smallGroups": [
        {"name": "Tech Team", "role": "Member"}
      ]
    },
    {
      "id": 8,
      "name": "Grace Nkrumah",
      "profileImage":
          "https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=400",
      "role": "Prayer Warrior",
      "ministry": "Intercessory Ministry",
      "ministryRole": "Prayer Coordinator",
      "phone": "+233201234567",
      "email": "grace.nkrumah@hotmail.com",
      "location": "Lapaz, Accra",
      "joinDate": "May 2016",
      "isFavorite": true,
      "isNewMember": false,
      "showPhone": true,
      "showEmail": true,
      "bio":
          "Committed to intercession and spiritual warfare, supporting church members through prayer.",
      "smallGroups": [
        {"name": "Prayer Warriors", "role": "Leader"},
        {"name": "Women's Prayer Group", "role": "Member"}
      ]
    }
  ];

  List<Map<String, dynamic>> _filteredMembers = [];
  List<String> _availableMinistries = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _filteredMembers = List.from(_allMembers);
          _availableMinistries = _allMembers
              .map((member) => member['ministry'] as String?)
              .where((ministry) => ministry != null)
              .cast<String>()
              .toSet()
              .toList()
            ..sort();
          _isLoading = false;
        });
      }
    });
  }

  void _filterMembers() {
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        final matchesSearch = _searchQuery.isEmpty ||
            (member['name'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (member['ministry'] as String? ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (member['location'] as String? ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        final matchesMinistry = _selectedMinistry == null ||
            member['ministry'] == _selectedMinistry;

        final matchesLetter = _selectedLetter == null ||
            (member['name'] as String)
                .toUpperCase()
                .startsWith(_selectedLetter!);

        return matchesSearch && matchesMinistry && matchesLetter;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _selectedLetter = null; // Clear letter filter when searching
    });
    _filterMembers();
  }

  void _onMinistrySelected(String? ministry) {
    setState(() {
      _selectedMinistry = ministry;
    });
    _filterMembers();
  }

  void _onLetterTap(String letter) {
    setState(() {
      _selectedLetter = _selectedLetter == letter ? null : letter;
      _searchQuery = ''; // Clear search when using letter filter
    });
    _filterMembers();

    if (_selectedLetter != null) {
      _scrollToLetter(letter);
    }
  }

  void _scrollToLetter(String letter) {
    final index = _filteredMembers.indexWhere(
      (member) => (member['name'] as String).toUpperCase().startsWith(letter),
    );

    if (index != -1 && _scrollController.hasClients) {
      final position = index * 120.0; // Approximate height per item
      _scrollController.animateTo(
        position,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleFavorite(int memberId) {
    setState(() {
      final memberIndex =
          _allMembers.indexWhere((member) => member['id'] == memberId);
      if (memberIndex != -1) {
        _allMembers[memberIndex]['isFavorite'] =
            !(_allMembers[memberIndex]['isFavorite'] ?? false);
      }
    });
    _filterMembers();

    HapticFeedback.lightImpact();
  }

  void _showMemberDetail(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MemberDetailModalWidget(
        member: member,
        onClose: () => Navigator.pop(context),
        onFavoriteToggle: () => _toggleFavorite(member['id']),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Ministry',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            MinistryFilterWidget(
              ministries: _availableMinistries,
              selectedMinistry: _selectedMinistry,
              onMinistrySelected: (ministry) {
                _onMinistrySelected(ministry);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupMembersByLetter() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final member in _filteredMembers) {
      final firstLetter = (member['name'] as String).toUpperCase()[0];
      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(member);
    }

    // Sort each group by name
    grouped.forEach((key, value) {
      value
          .sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    });

    return grouped;
  }

  Widget _buildMembersList() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredMembers.isEmpty) {
      return _buildEmptyState();
    }

    final groupedMembers = _groupMembersByLetter();
    final sortedKeys = groupedMembers.keys.toList()..sort();

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: sortedKeys.length * 2, // Header + members for each letter
      itemBuilder: (context, index) {
        final letterIndex = index ~/ 2;
        final isHeader = index % 2 == 0;

        if (letterIndex >= sortedKeys.length) return SizedBox.shrink();

        final letter = sortedKeys[letterIndex];
        final members = groupedMembers[letter]!;

        if (isHeader) {
          return SectionHeaderWidget(
            letter: letter,
            memberCount: members.length,
          );
        } else {
          return Column(
            children: members.map((member) {
              return MemberCardWidget(
                member: member,
                onTap: () => _showMemberDetail(member),
                onFavoriteToggle: () => _toggleFavorite(member['id']),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 2.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          height: 1.5.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'people_outline',
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No members found'
                  : 'No members available',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search criteria or check spelling'
                  : 'Member directory is currently empty',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty) ...[
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _selectedMinistry = null;
                    _selectedLetter = null;
                  });
                  _filterMembers();
                },
                child: Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar.secondary(
        title: 'Member Directory',
        actions: [
          if (_isOffline)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'wifi_off',
                    color: AppTheme.warningLight,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Offline',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            hintText: 'Search members, ministry, location...',
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterOptions,
          ),

          // Ministry Filter
          if (_availableMinistries.isNotEmpty)
            MinistryFilterWidget(
              ministries: _availableMinistries,
              selectedMinistry: _selectedMinistry,
              onMinistrySelected: _onMinistrySelected,
            ),

          // Members List with Alphabetical Index
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildMembersList(),
                ),
                AlphabeticalIndexWidget(
                  onLetterTap: _onLetterTap,
                  selectedLetter: _selectedLetter,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.main(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }
}
