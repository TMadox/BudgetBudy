import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Saving {
  final int id;
  final String title;
  final num amount;
  final DateTime date;
  final int targetId;
  Saving({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.targetId,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'amount': amount,
        'date': date.millisecondsSinceEpoch,
        'targetId': targetId,
      };

  factory Saving.fromMap(Map<String, dynamic> map) => Saving(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        title: map['title'] as String,
        amount: map['amount'] as num,
        date: DateTime.fromMillisecondsSinceEpoch(map['date']),
        targetId: map['targetId'],
      );

  String toJson() => json.encode(toMap());

  factory Saving.fromJson(String source) => Saving.fromMap(json.decode(source) as Map<String, dynamic>);
}
