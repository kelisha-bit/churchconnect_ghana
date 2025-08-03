class AppConstants {
  // Church Information
  static const String churchName = 'Greater Works City Church';
  static const String churchLocation = 'Ghana';
  static const String churchPhone = '+233 XX XXX XXXX';
  static const String churchEmail = 'info@greaterworkschurch.com';
  static const String churchWebsite = 'www.greaterworkschurch.com';

  // App Information
  static const String appName = 'Church Connect Ghana';
  static const String appVersion = '1.0.0';

  // Default Values
  static const String defaultProfileImage = 'https://via.placeholder.com/150';
  static const String defaultEventImage = 'https://via.placeholder.com/300x200';
  static const String noImagePlaceholder = 'assets/images/no-image.jpg';

  // Church Ministries
  static const List<String> ministries = [
    'men_ministry',
    'youth_ministry',
    'women_ministry',
    'children_ministry',
    'all'
  ];

  // Church Departments
  static const List<String> departments = [
    'music',
    'usher_cleaner',
    'media',
    'finance',
    'welfare',
    'sunday_school',
    'account',
    'welfare_committee',
    'choir',
    'cleaners',
    'n_a'
  ];

  // Membership Types
  static const List<String> membershipTypes = [
    'full_member',
    'friend_of_church',
    'new_convert',
    'visitor',
    'others',
    'regular',
    'leadership'
  ];

  // Member Status
  static const List<String> memberStatus = ['active', 'inactive'];

  // Event Types
  static const List<String> eventTypes = [
    'service',
    'bible_study',
    'prayer',
    'fellowship',
    'conference',
    'workshop',
    'outreach',
    'special_service'
  ];

  // Prayer Request Categories
  static const List<String> prayerCategories = [
    'healing',
    'family',
    'financial',
    'spiritual_growth',
    'guidance',
    'thanksgiving',
    'general'
  ];

  // Prayer Request Status
  static const List<String> prayerStatus = [
    'pending',
    'in_progress',
    'answered',
    'closed'
  ];

  // Donation Types
  static const List<String> donationTypes = [
    'tithe',
    'offering',
    'seed_offering',
    'building_fund',
    'mission_offering',
    'special_offering'
  ];

  // Payment Methods
  static const List<String> paymentMethods = [
    'cash',
    'mobile_money',
    'bank_transfer',
    'cheque',
    'card'
  ];

  // Gender Options
  static const List<String> genderOptions = ['male', 'female'];

  // Marital Status Options
  static const List<String> maritalStatusOptions = [
    'single',
    'married',
    'divorced',
    'widowed'
  ];

  // Education Levels
  static const List<String> educationLevels = [
    'primary',
    'secondary',
    'diploma',
    'other'
  ];

  // Baptism Status
  static const List<String> baptismStatus = ['baptized', 'not_baptized'];

  // Service Times
  static const Map<String, String> serviceTimes = {
    'Sunday Morning Service': '9:00 AM - 11:30 AM',
    'Sunday Evening Service': '5:00 PM - 7:00 PM',
    'Wednesday Bible Study': '6:00 PM - 8:00 PM',
    'Friday Prayer Meeting': '6:00 PM - 8:00 PM',
  };

  // Storage Bucket Names
  static const String profileImagesBucket = 'profile-photos';
  static const String eventImagesBucket = 'event-images';
  static const String avatarsBucket = 'avatars';
  static const String heroImagesBucket = 'hero-images';

  // API Endpoints (if needed)
  static const String baseUrl = 'https://your-api-url.com';

  // App Colors (complement existing theme)
  static const String primaryColorHex = '#1976D2';
  static const String secondaryColorHex = '#FFC107';
  static const String successColorHex = '#4CAF50';
  static const String errorColorHex = '#F44336';
  static const String warningColorHex = '#FF9800';

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxNotesLength = 1000;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration (in minutes)
  static const int cacheDuration = 30;

  // Feature Flags
  static const bool enableRealTimeUpdates = true;
  static const bool enableNotifications = true;
  static const bool enableOfflineMode = false;

  // Default Texts
  static const String welcomeMessage = 'Welcome to Greater Works City Church';
  static const String noDataMessage = 'No data available';
  static const String loadingMessage = 'Loading...';
  static const String errorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'Please check your internet connection';

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd MMM yyyy HH:mm';

  // Helper Methods
  static String getDisplayName(String value) {
    return value.replaceAll('_', ' ').toUpperCase();
  }

  static String formatPhoneNumber(String phone) {
    // Add Ghana country code if not present
    if (!phone.startsWith('+233') && !phone.startsWith('233')) {
      if (phone.startsWith('0')) {
        return '+233${phone.substring(1)}';
      } else {
        return '+233$phone';
      }
    }
    return phone;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
  }
}
