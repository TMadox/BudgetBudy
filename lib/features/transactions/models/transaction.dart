// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Transaction {
  final int id;
  final String title;
  //Changed int to num to better suit the narrative
  final num amount;
  final DateTime date;
  final String category;
//Added required in constructor to avoid error as this is a required field,
//and because the project is now using null safety
  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
  //Removed the input parameter as it is not needed,
  //we can directly call this function using the an instance of the class
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'amount': amount,
        'date': date.millisecondsSinceEpoch,
        'category': category,
      };

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        title: map['title'],
        amount: map['amount'],
        date: DateTime.fromMillisecondsSinceEpoch(map['date']),
        category: map['category'],
      );

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source) as Map<String, dynamic>);
}
