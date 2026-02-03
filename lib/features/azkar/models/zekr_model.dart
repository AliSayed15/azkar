class ZekrItem {
  final String category;
  final String content;
  final String description;
  final int count;
  int currentCount;

  ZekrItem({
    required this.category,
    required this.content,
    required this.description,
    required this.count,
  }) : currentCount = count;

  factory ZekrItem.fromJson(Map<String, dynamic> json) {
    return ZekrItem(
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      count: int.tryParse(json['count'].toString()) ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'content': content,
      'description': description,
      'count': count,
      'currentCount': currentCount,
    };
  }
}