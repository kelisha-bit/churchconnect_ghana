import '../models/donation_model.dart';
import '../services/supabase_service.dart';

class DonationService {
  static DonationService? _instance;
  static DonationService get instance => _instance ??= DonationService._();
  DonationService._();

  final _client = SupabaseService.instance.client;

  // Get all donations
  Future<List<DonationModel>> getAllDonations() async {
    try {
      final response = await _client
          .from('donations')
          .select()
          .order('donation_date', ascending: false);

      return response
          .map<DonationModel>((json) => DonationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get donations: $error');
    }
  }

  // Get donations by type (tithe, offering, etc.)
  Future<List<DonationModel>> getDonationsByType(String donationType) async {
    try {
      final response = await _client
          .from('donations')
          .select()
          .eq('donation_type', donationType)
          .order('donation_date', ascending: false);

      return response
          .map<DonationModel>((json) => DonationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get donations by type: $error');
    }
  }

  // Get donations by date range
  Future<List<DonationModel>> getDonationsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final response = await _client
          .from('donations')
          .select()
          .gte('donation_date', startDate.toIso8601String().split('T')[0])
          .lte('donation_date', endDate.toIso8601String().split('T')[0])
          .order('donation_date', ascending: false);

      return response
          .map<DonationModel>((json) => DonationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get donations by date range: $error');
    }
  }

  // Get member's donations
  Future<List<DonationModel>> getMemberDonations(String memberId) async {
    try {
      final response = await _client
          .from('donations')
          .select()
          .eq('member_id', memberId)
          .order('donation_date', ascending: false);

      return response
          .map<DonationModel>((json) => DonationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get member donations: $error');
    }
  }

  // Search donations by donor name
  Future<List<DonationModel>> searchDonationsByDonor(String donorName) async {
    try {
      final response = await _client
          .from('donations')
          .select()
          .ilike('donor_name', '%$donorName%')
          .order('donation_date', ascending: false);

      return response
          .map<DonationModel>((json) => DonationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to search donations by donor: $error');
    }
  }

  // Get donation by ID
  Future<DonationModel?> getDonationById(String id) async {
    try {
      final response =
          await _client.from('donations').select().eq('id', id).single();

      return DonationModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get donation: $error');
    }
  }

  // Add new donation
  Future<DonationModel> addDonation(DonationModel donation) async {
    try {
      final response = await _client
          .from('donations')
          .insert(donation.toJson())
          .select()
          .single();

      return DonationModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to add donation: $error');
    }
  }

  // Update donation
  Future<DonationModel> updateDonation(DonationModel donation) async {
    try {
      final response = await _client
          .from('donations')
          .update(donation.toJson())
          .eq('id', donation.id)
          .select()
          .single();

      return DonationModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update donation: $error');
    }
  }

  // Delete donation
  Future<void> deleteDonation(String id) async {
    try {
      await _client.from('donations').delete().eq('id', id);
    } catch (error) {
      throw Exception('Failed to delete donation: $error');
    }
  }

  // Get donation statistics
  Future<Map<String, dynamic>> getDonationStatistics() async {
    try {
      final totalAmountResponse = await _client.rpc('get_total_donations');

      final thisMonthAmountResponse =
          await _client.rpc('get_monthly_donations', params: {
        'target_month': DateTime.now().month,
        'target_year': DateTime.now().year,
      });

      final totalCountResponse =
          await _client.from('donations').select('id').count();

      final thisMonthCountResponse = await _client
          .from('donations')
          .select('id')
          .gte(
              'donation_date',
              DateTime(DateTime.now().year, DateTime.now().month, 1)
                  .toIso8601String()
                  .split('T')[0])
          .count();

      return {
        'total_amount': totalAmountResponse ?? 0,
        'this_month_amount': thisMonthAmountResponse ?? 0,
        'total_donations': totalCountResponse.count ?? 0,
        'this_month_donations': thisMonthCountResponse.count ?? 0,
      };
    } catch (error) {
      // Fallback calculation if RPC functions don't exist
      try {
        final allDonations = await getAllDonations();
        final totalAmount = allDonations.fold<double>(
            0, (sum, donation) => sum + donation.amount);

        final thisMonth = DateTime.now();
        final thisMonthDonations = allDonations
            .where((donation) =>
                donation.donationDate.year == thisMonth.year &&
                donation.donationDate.month == thisMonth.month)
            .toList();

        final thisMonthAmount = thisMonthDonations.fold<double>(
            0, (sum, donation) => sum + donation.amount);

        return {
          'total_amount': totalAmount,
          'this_month_amount': thisMonthAmount,
          'total_donations': allDonations.length,
          'this_month_donations': thisMonthDonations.length,
        };
      } catch (e) {
        throw Exception('Failed to get donation statistics: $error');
      }
    }
  }

  // Get recent donations
  Future<List<DonationModel>> getRecentDonations({int limit = 10}) async {
    try {
      final response = await _client
          .from('donations')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map<DonationModel>((json) => DonationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get recent donations: $error');
    }
  }

  // Get donations by payment method
  Future<List<DonationModel>> getDonationsByPaymentMethod(
      String paymentMethod) async {
    try {
      final response = await _client
          .from('donations')
          .select()
          .eq('payment_method', paymentMethod)
          .order('donation_date', ascending: false);

      return response
          .map<DonationModel>((json) => DonationModel.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get donations by payment method: $error');
    }
  }

  // Get monthly donation totals for chart
  Future<List<Map<String, dynamic>>> getMonthlyDonationTotals(int year) async {
    try {
      final response = await _client
          .from('donations')
          .select('donation_date, amount')
          .gte('donation_date', '$year-01-01')
          .lt('donation_date', '${year + 1}-01-01')
          .order('donation_date', ascending: true);

      // Group by month and sum amounts
      final monthlyTotals = <int, double>{};
      for (final donation in response) {
        final date = DateTime.parse(donation['donation_date']);
        final month = date.month;
        final amount = double.parse(donation['amount'].toString());
        monthlyTotals[month] = (monthlyTotals[month] ?? 0) + amount;
      }

      // Convert to list format for charts
      return List.generate(
          12,
          (index) => {
                'month': index + 1,
                'amount': monthlyTotals[index + 1] ?? 0,
              });
    } catch (error) {
      throw Exception('Failed to get monthly donation totals: $error');
    }
  }
}
