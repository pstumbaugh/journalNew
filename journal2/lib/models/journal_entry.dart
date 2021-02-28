import '../imports.dart';

class JournalEntry {
  final String title;
  final String body;
  final int rate;
  final String date;

  JournalEntry({this.title, this.body, this.rate, this.date});

//converts to one string
  String toString() {
    return 'Title: $title, Body: $body, Rating: $rate, Date: $date';
  }
}
