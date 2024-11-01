import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Target {
  final int id;
  final String title;
  final num amount;
  final num percentage;
  final DateTime endDate;
  final DateTime startDate;
  final DateTime createdAt;
  Target({
    required this.id,
    required this.title,
    required this.amount,
    required this.endDate,
    required this.startDate,
    required this.createdAt,
    required this.percentage,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'amount': amount,
        'percentage': percentage,
        'endDate': endDate.millisecondsSinceEpoch,
        'startDate': startDate.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory Target.fromMap(Map<String, dynamic> map) => Target(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        title: map['title'],
        amount: map['amount'],
        percentage: map['percentage'] ?? 0,
        endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
        startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
        createdAt: map['createdAt'] == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      );

  String toJson() => json.encode(toMap());

  factory Target.fromJson(String source) => Target.fromMap(json.decode(source) as Map<String, dynamic>);

  Target copyWith({
    int? id,
    String? title,
    num? amount,
    num? percentage,
    DateTime? endDate,
    DateTime? startDate,
    DateTime? createdAt,
  }) {
    return Target(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
