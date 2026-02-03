class AzkarSection {
  final String title;
  final List<DhikrApiItem> items;

  AzkarSection({
    required this.title,
    required this.items,
  });

  factory AzkarSection.fromJson(Map<String, dynamic> json) {
    return AzkarSection(
      title: json['title'] ?? '',
      items: (json['content'] as List)
          .map((e) => DhikrApiItem.fromJson(e))
          .toList(),
    );
  }
}

class DhikrApiItem {
  final String zekr;
  final int repeat;
  final String? bless;
  final String? source;

  DhikrApiItem({
    required this.zekr,
    required this.repeat,
    this.bless,
    this.source,
  });

  factory DhikrApiItem.fromJson(Map<String, dynamic> json) {
    return DhikrApiItem(
      zekr: json['zekr'] ?? '',
      repeat: json['repeat'] ?? 1,
      bless: json['bless'],
      source: json['source'],
    );
  }
}