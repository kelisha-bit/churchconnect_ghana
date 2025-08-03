import '../models/prayer_request_model.dart';
import '../services/supabase_service.dart';

class PrayerService {
  static PrayerService? _instance;
  static PrayerService get instance => _instance ??= PrayerService._();
  PrayerService._();

  final _client = SupabaseService.instance.client;

  // Get all public prayer requests
  Future<List<PrayerRequestModel>> getPublicPrayerRequests() async {
    try {
      final response = await _client
          .from('prayer_requests')
          .select()
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return response
          .map<PrayerRequestModel>((json) => PrayerRequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get public prayer requests: $error');
    }
  }

  // Get user's prayer requests
  Future<List<PrayerRequestModel>> getUserPrayerRequests(String userId) async {
    try {
      final response = await _client
          .from('prayer_requests')
          .select()
          .eq('requester_id', userId)
          .order('created_at', ascending: false);

      return response
          .map<PrayerRequestModel>((json) => PrayerRequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get user prayer requests: $error');
    }
  }

  // Get prayer requests by category
  Future<List<PrayerRequestModel>> getPrayerRequestsByCategory(
      String category) async {
    try {
      final response = await _client
          .from('prayer_requests')
          .select()
          .eq('category', category)
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return response
          .map<PrayerRequestModel>((json) => PrayerRequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get prayer requests by category: $error');
    }
  }

  // Get prayer requests by status
  Future<List<PrayerRequestModel>> getPrayerRequestsByStatus(
      String status) async {
    try {
      final response = await _client
          .from('prayer_requests')
          .select()
          .eq('status', status)
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return response
          .map<PrayerRequestModel>((json) => PrayerRequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get prayer requests by status: $error');
    }
  }

  // Search prayer requests
  Future<List<PrayerRequestModel>> searchPrayerRequests(String query) async {
    try {
      final response = await _client
          .from('prayer_requests')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return response
          .map<PrayerRequestModel>((json) => PrayerRequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to search prayer requests: $error');
    }
  }

  // Get prayer request by ID
  Future<PrayerRequestModel?> getPrayerRequestById(String id) async {
    try {
      final response =
          await _client.from('prayer_requests').select().eq('id', id).single();

      return PrayerRequestModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get prayer request: $error');
    }
  }

  // Add new prayer request
  Future<PrayerRequestModel> addPrayerRequest(
      PrayerRequestModel prayerRequest) async {
    try {
      final response = await _client
          .from('prayer_requests')
          .insert(prayerRequest.toJson())
          .select()
          .single();

      return PrayerRequestModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to add prayer request: $error');
    }
  }

  // Update prayer request
  Future<PrayerRequestModel> updatePrayerRequest(
      PrayerRequestModel prayerRequest) async {
    try {
      final response = await _client
          .from('prayer_requests')
          .update(prayerRequest.toJson())
          .eq('id', prayerRequest.id)
          .select()
          .single();

      return PrayerRequestModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update prayer request: $error');
    }
  }

  // Delete prayer request
  Future<void> deletePrayerRequest(String id) async {
    try {
      await _client.from('prayer_requests').delete().eq('id', id);
    } catch (error) {
      throw Exception('Failed to delete prayer request: $error');
    }
  }

  // Get prayer request statistics
  Future<Map<String, dynamic>> getPrayerRequestStatistics() async {
    try {
      final totalResponse =
          await _client.from('prayer_requests').select('id').count();

      final publicResponse = await _client
          .from('prayer_requests')
          .select('id')
          .eq('is_public', true)
          .count();

      final thisWeekResponse = await _client
          .from('prayer_requests')
          .select('id')
          .gte(
              'created_at',
              DateTime.now()
                  .subtract(const Duration(days: 7))
                  .toIso8601String())
          .count();

      return {
        'total_requests': totalResponse.count ?? 0,
        'public_requests': publicResponse.count ?? 0,
        'new_this_week': thisWeekResponse.count ?? 0,
      };
    } catch (error) {
      throw Exception('Failed to get prayer request statistics: $error');
    }
  }

  // Get urgent prayer requests
  Future<List<PrayerRequestModel>> getUrgentPrayerRequests() async {
    try {
      final response = await _client
          .from('prayer_requests')
          .select()
          .eq('urgency', 'urgent')
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return response
          .map<PrayerRequestModel>((json) => PrayerRequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get urgent prayer requests: $error');
    }
  }

  // Get recent prayer requests
  Future<List<PrayerRequestModel>> getRecentPrayerRequests(
      {int limit = 10}) async {
    try {
      final response = await _client
          .from('prayer_requests')
          .select()
          .eq('is_public', true)
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map<PrayerRequestModel>((json) => PrayerRequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get recent prayer requests: $error');
    }
  }

  // Subscribe to prayer request changes (Real-time)
  void subscribeToPrayerRequests(
      Function(List<PrayerRequestModel>) onRequestsChanged) {
    _client
        .channel('public:prayer_requests')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'prayer_requests',
          callback: (payload) async {
            // Reload prayer requests when changes occur
            final requests = await getPublicPrayerRequests();
            onRequestsChanged(requests);
          },
        )
        .subscribe();
  }
}