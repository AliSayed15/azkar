class DetailedZekr {
  final int id;
  final String category;
  final String text;
  final int count;
  final String? reference;
  final String? benefit;
  final int order;

  DetailedZekr({
    required this.id,
    required this.category,
    required this.text,
    required this.count,
    this.reference,
    this.benefit,
    required this.order,
  });

  factory DetailedZekr.fromJson(Map<String, dynamic> json) {
    return DetailedZekr(
      id: json['id'] as int,
      category: json['category'] as String,
      text: json['text'] as String,
      count: json['count'] as int? ?? 1,
      reference: json['reference'] as String?,
      benefit: json['benefit'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'text': text,
      'count': count,
      'reference': reference,
      'benefit': benefit,
      'order': order,
    };
  }
}