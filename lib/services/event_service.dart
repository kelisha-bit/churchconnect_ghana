import '../models/event_model.dart';
import '../services/supabase_service.dart';

class EventService {
  static EventService? _instance;
  static EventService get instance => _instance ??= EventService._();
  EventService._();

  final _client = SupabaseService.instance.client;

  // Get all events
  Future<List<EventModel>> getAllEvents() async {
    try {
      final response = await _client
          .from('events')
          .select()
          .order('event_date', ascending: true);

      return response
          .map<EventModel>((json) => EventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get events: $error');
    }
  }

  // Get upcoming events
  Future<List<EventModel>> getUpcomingEvents({int limit = 10}) async {
    try {
      final response = await _client
          .from('events')
          .select()
          .gte('event_date', DateTime.now().toIso8601String().split('T')[0])
          .order('event_date', ascending: true)
          .limit(limit);

      return response
          .map<EventModel>((json) => EventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get upcoming events: $error');
    }
  }

  // Get events by type
  Future<List<EventModel>> getEventsByType(String eventType) async {
    try {
      final response = await _client
          .from('events')
          .select()
          .eq('event_type', eventType)
          .order('event_date', ascending: true);

      return response
          .map<EventModel>((json) => EventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get events by type: $error');
    }
  }

  // Get events for a specific date
  Future<List<EventModel>> getEventsByDate(DateTime date) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];
      final response = await _client
          .from('events')
          .select()
          .eq('event_date', dateString)
          .order('start_time', ascending: true);

      return response
          .map<EventModel>((json) => EventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get events by date: $error');
    }
  }

  // Search events
  Future<List<EventModel>> searchEvents(String query) async {
    try {
      final response = await _client
          .from('events')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%,location.ilike.%$query%')
          .order('event_date', ascending: true);

      return response
          .map<EventModel>((json) => EventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to search events: $error');
    }
  }

  // Get event by ID
  Future<EventModel?> getEventById(String id) async {
    try {
      final response =
          await _client.from('events').select().eq('id', id).single();

      return EventModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get event: $error');
    }
  }

  // Add new event
  Future<EventModel> addEvent(EventModel event) async {
    try {
      final response =
          await _client.from('events').insert(event.toJson()).select().single();

      return EventModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to add event: $error');
    }
  }

  // Update event
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final response = await _client
          .from('events')
          .update(event.toJson())
          .eq('id', event.id)
          .select()
          .single();

      return EventModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update event: $error');
    }
  }

  // Delete event
  Future<void> deleteEvent(String id) async {
    try {
      await _client.from('events').delete().eq('id', id);
    } catch (error) {
      throw Exception('Failed to delete event: $error');
    }
  }

  // Get event statistics
  Future<Map<String, dynamic>> getEventStatistics() async {
    try {
      final totalResponse = await _client.from('events').select('id').count();

      final upcomingResponse = await _client
          .from('events')
          .select('id')
          .gte('event_date', DateTime.now().toIso8601String().split('T')[0])
          .count();

      final thisMonthResponse = await _client
          .from('events')
          .select('id')
          .gte(
              'event_date',
              DateTime(DateTime.now().year, DateTime.now().month, 1)
                  .toIso8601String()
                  .split('T')[0])
          .lt(
              'event_date',
              DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
                  .toIso8601String()
                  .split('T')[0])
          .count();

      return {
        'total_events': totalResponse.count ?? 0,
        'upcoming_events': upcomingResponse.count ?? 0,
        'this_month_events': thisMonthResponse.count ?? 0,
      };
    } catch (error) {
      throw Exception('Failed to get event statistics: $error');
    }
  }

  // Get events by date range
  Future<List<EventModel>> getEventsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final response = await _client
          .from('events')
          .select()
          .gte('event_date', startDate.toIso8601String().split('T')[0])
          .lte('event_date', endDate.toIso8601String().split('T')[0])
          .order('event_date', ascending: true);

      return response
          .map<EventModel>((json) => EventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get events by date range: $error');
    }
  }

  // Get today's events
  Future<List<EventModel>> getTodayEvents() async {
    try {
      return await getEventsByDate(DateTime.now());
    } catch (error) {
      throw Exception('Failed to get today\'s events: $error');
    }
  }

  // Subscribe to event changes (Real-time)
  void subscribeToEvents(Function(List<EventModel>) onEventsChanged) {
    _client
        .channel('public:events')
        .onPostgresChanges(
          event: '*',
          schema: 'public',
          table: 'events',
          callback: (payload) async {
            // Reload events when changes occur
            final events = await getAllEvents();
            onEventsChanged(events);
          },
        )
        .subscribe();
  }
}