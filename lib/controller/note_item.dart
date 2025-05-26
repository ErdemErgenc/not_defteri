class NoteItem {
  final String text;
  final DateTime date;

  NoteItem({required this.text, required this.date});

  // GetStorage için Map'e çevirme
  Map<String, dynamic> toJson() => {
    'text': text,
    'date': date.toIso8601String(),
  };

  factory NoteItem.fromJson(Map<String, dynamic> json) =>
      NoteItem(text: json['text'], date: DateTime.parse(json['date']));
}
