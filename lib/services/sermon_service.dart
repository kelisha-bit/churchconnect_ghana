import '../models/sermon_model.dart';
import '../services/supabase_service.dart';

class SermonService {
  static SermonService? _instance;
  static SermonService get instance => _instance ??= SermonService._();
  SermonService._();

  final _client = SupabaseService.instance.client;

  // Get all sermons
  Future<List<SermonModel>> getAllSermons() async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .order('date', ascending: false);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get sermons: $error');
    }
  }

  // Get sermons by category
  Future<List<SermonModel>> getSermonsByCategory(String category) async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .eq('category', category)
          .order('date', ascending: false);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get sermons by category: $error');
    }
  }

  // Get sermons by preacher
  Future<List<SermonModel>> getSermonsByPreacher(String preacher) async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .eq('preacher', preacher)
          .order('date', ascending: false);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get sermons by preacher: $error');
    }
  }

  // Search sermons
  Future<List<SermonModel>> searchSermons(String query) async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%,preacher.ilike.%$query%,scripture_reference.ilike.%$query%')
          .order('date', ascending: false);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to search sermons: $error');
    }
  }

  // Get sermon by ID
  Future<SermonModel?> getSermonById(String id) async {
    try {
      final response =
          await _client.from('sermons').select().eq('id', id).single();

      return SermonModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get sermon: $error');
    }
  }

  // Add new sermon
  Future<SermonModel> addSermon(SermonModel sermon) async {
    try {
      final response = await _client
          .from('sermons')
          .insert(sermon.toJson())
          .select()
          .single();

      return SermonModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to add sermon: $error');
    }
  }

  // Update sermon
  Future<SermonModel> updateSermon(SermonModel sermon) async {
    try {
      final response = await _client
          .from('sermons')
          .update(sermon.toJson())
          .eq('id', sermon.id)
          .select()
          .single();

      return SermonModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update sermon: $error');
    }
  }

  // Delete sermon
  Future<void> deleteSermon(String id) async {
    try {
      await _client.from('sermons').delete().eq('id', id);
    } catch (error) {
      throw Exception('Failed to delete sermon: $error');
    }
  }

  // Get recent sermons
  Future<List<SermonModel>> getRecentSermons({int limit = 10}) async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .order('date', ascending: false)
          .limit(limit);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get recent sermons: $error');
    }
  }

  // Get sermons by date range
  Future<List<SermonModel>> getSermonsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', endDate.toIso8601String().split('T')[0])
          .order('date', ascending: false);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get sermons by date range: $error');
    }
  }

  // Get sermons with audio
  Future<List<SermonModel>> getSermonsWithAudio() async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .not('audio_url', 'is', null)
          .order('date', ascending: false);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get sermons with audio: $error');
    }
  }

  // Get sermons with video
  Future<List<SermonModel>> getSermonsWithVideo() async {
    try {
      final response = await _client
          .from('sermons')
          .select()
          .not('video_url', 'is', null)
          .order('date', ascending: false);

      return response
          .map<SermonModel>((json) => SermonModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get sermons with video: $error');
    }
  }

  // Get sermon statistics
  Future<Map<String, dynamic>> getSermonStatistics() async {
    try {
      final totalResponse = await _client.from('sermons').select('id').count();

      final withAudioResponse = await _client
          .from('sermons')
          .select('id')
          .not('audio_url', 'is', null)
          .count();

      final withVideoResponse = await _client
          .from('sermons')
          .select('id')
          .not('video_url', 'is', null)
          .count();

      final thisMonthResponse = await _client
          .from('sermons')
          .select('id')
          .gte(
              'date',
              DateTime(DateTime.now().year, DateTime.now().month, 1)
                  .toIso8601String()
                  .split('T')[0])
          .count();

      return {
        'total_sermons': totalResponse.count ?? 0,
        'sermons_with_audio': withAudioResponse.count ?? 0,
        'sermons_with_video': withVideoResponse.count ?? 0,
        'this_month_sermons': thisMonthResponse.count ?? 0,
      };
    } catch (error) {
      throw Exception('Failed to get sermon statistics: $error');
    }
  }

  // Get unique preachers
  Future<List<String>> getUniquePreachers() async {
    try {
      final response = await _client
          .from('sermons')
          .select('preacher')
          .not('preacher', 'is', null);

      final preachers = response
          .map<String>((json) => json['preacher'] as String)
          .toSet()
          .toList();

      preachers.sort();
      return preachers;
    } catch (error) {
      throw Exception('Failed to get unique preachers: $error');
    }
  }

  // Get unique categories
  Future<List<String>> getUniqueCategories() async {
    try {
      final response = await _client
          .from('sermons')
          .select('category')
          .not('category', 'is', null);

      final categories = response
          .map<String>((json) => json['category'] as String)
          .toSet()
          .toList();

      categories.sort();
      return categories;
    } catch (error) {
      throw Exception('Failed to get unique categories: $error');
    }
  }
}
