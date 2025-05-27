class NoteItem {
  final String text;
  final DateTime date;
  final int colorIndex; // Yeni

  NoteItem({
    required this.text,
    required this.date,
    this.colorIndex = 0, // Default renk indeksi 0
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'date': date.toIso8601String(),
    'colorIndex': colorIndex,
  };

  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
    text: json['text'],
    date: DateTime.parse(json['date']),
    colorIndex: json['colorIndex'] ?? 0, // null gelirse 0 ata
  );
}
