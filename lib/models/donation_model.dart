class DonationModel {
  final String id;
  final String donorName;
  final String? donorEmail;
  final String? donorPhone;
  final double amount;
  final String donationType;
  final String paymentMethod;
  final DateTime donationDate;
  final bool isRecurring;
  final String? referenceNumber;
  final String? notes;
  final String? memberId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DonationModel({
    required this.id,
    required this.donorName,
    this.donorEmail,
    this.donorPhone,
    required this.amount,
    required this.donationType,
    required this.paymentMethod,
    required this.donationDate,
    required this.isRecurring,
    this.referenceNumber,
    this.notes,
    this.memberId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] ?? '',
      donorName: json['donor_name'] ?? '',
      donorEmail: json['donor_email'],
      donorPhone: json['donor_phone'],
      amount: double.parse(json['amount'].toString()),
      donationType: json['donation_type'] ?? 'tithe',
      paymentMethod: json['payment_method'] ?? 'cash',
      donationDate: DateTime.parse(
          json['donation_date'] ?? DateTime.now().toIso8601String()),
      isRecurring: json['is_recurring'] ?? false,
      referenceNumber: json['reference_number'],
      notes: json['notes'],
      memberId: json['member_id'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donor_name': donorName,
      'donor_email': donorEmail,
      'donor_phone': donorPhone,
      'amount': amount,
      'donation_type': donationType,
      'payment_method': paymentMethod,
      'donation_date': donationDate.toIso8601String().split('T')[0],
      'is_recurring': isRecurring,
      'reference_number': referenceNumber,
      'notes': notes,
      'member_id': memberId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayType => donationType.replaceAll('_', ' ').toUpperCase();

  String get displayPaymentMethod =>
      paymentMethod.replaceAll('_', ' ').toUpperCase();

  String get formattedAmount => 'GH₵ ${amount.toStringAsFixed(2)}';

  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${donationDate.day} ${months[donationDate.month - 1]} ${donationDate.year}';
  }
}
