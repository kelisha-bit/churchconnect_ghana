import '../models/member_model.dart';
import '../services/supabase_service.dart';

class MemberService {
  static MemberService? _instance;
  static MemberService get instance => _instance ??= MemberService._();
  MemberService._();

  final _client = SupabaseService.instance.client;

  // Get all members
  Future<List<MemberModel>> getAllMembers() async {
    try {
      final response = await _client
          .from('members')
          .select()
          .order('first_name', ascending: true);

      return response
          .map<MemberModel>((json) => MemberModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get members: $error');
    }
  }

  // Get members by ministry
  Future<List<MemberModel>> getMembersByMinistry(String ministry) async {
    try {
      final response = await _client
          .from('members')
          .select()
          .eq('ministry', ministry)
          .order('first_name', ascending: true);

      return response
          .map<MemberModel>((json) => MemberModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get members by ministry: $error');
    }
  }

  // Search members
  Future<List<MemberModel>> searchMembers(String query) async {
    try {
      final response = await _client
          .from('members')
          .select()
          .or('first_name.ilike.%$query%,last_name.ilike.%$query%,email.ilike.%$query%')
          .order('first_name', ascending: true);

      return response
          .map<MemberModel>((json) => MemberModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to search members: $error');
    }
  }

  // Get member by ID
  Future<MemberModel?> getMemberById(String id) async {
    try {
      final response =
          await _client.from('members').select().eq('id', id).single();

      return MemberModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get member: $error');
    }
  }

  // Add new member
  Future<MemberModel> addMember(MemberModel member) async {
    try {
      final response = await _client
          .from('members')
          .insert(member.toJson())
          .select()
          .single();

      return MemberModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to add member: $error');
    }
  }

  // Update member
  Future<MemberModel> updateMember(MemberModel member) async {
    try {
      final response = await _client
          .from('members')
          .update(member.toJson())
          .eq('id', member.id)
          .select()
          .single();

      return MemberModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update member: $error');
    }
  }

  // Delete member
  Future<void> deleteMember(String id) async {
    try {
      await _client.from('members').delete().eq('id', id);
    } catch (error) {
      throw Exception('Failed to delete member: $error');
    }
  }

  // Get member statistics
  Future<Map<String, dynamic>> getMemberStatistics() async {
    try {
      final totalResponse = await _client.from('members').select('id').count();

      final activeResponse = await _client
          .from('members')
          .select('id')
          .eq('membership_status', 'active')
          .count();

      final newThisMonthResponse = await _client
          .from('members')
          .select('id')
          .gte(
              'created_at',
              DateTime(DateTime.now().year, DateTime.now().month, 1)
                  .toIso8601String())
          .count();

      return {
        'total_members': totalResponse.count ?? 0,
        'active_members': activeResponse.count ?? 0,
        'new_this_month': newThisMonthResponse.count ?? 0,
      };
    } catch (error) {
      throw Exception('Failed to get member statistics: $error');
    }
  }

  // Get members by status
  Future<List<MemberModel>> getMembersByStatus(String status) async {
    try {
      final response = await _client
          .from('members')
          .select()
          .eq('membership_status', status)
          .order('first_name', ascending: true);

      return response
          .map<MemberModel>((json) => MemberModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get members by status: $error');
    }
  }

  // Get recent members
  Future<List<MemberModel>> getRecentMembers({int limit = 10}) async {
    try {
      final response = await _client
          .from('members')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map<MemberModel>((json) => MemberModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get recent members: $error');
    }
  }

  // Get birthday members for current month
  Future<List<MemberModel>> getMembersWithBirthdaysThisMonth() async {
    try {
      final currentMonth = DateTime.now().month;
      final response = await _client
          .from('members')
          .select()
          .not('date_of_birth', 'is', null)
          .order('first_name', ascending: true);

      final members = response
          .map<MemberModel>((json) => MemberModel.fromJson(json))
          .toList();

      return members
          .where((member) =>
              member.dateOfBirth != null &&
              member.dateOfBirth!.month == currentMonth)
          .toList();
    } catch (error) {
      throw Exception('Failed to get birthday members: $error');
    }
  }
}
