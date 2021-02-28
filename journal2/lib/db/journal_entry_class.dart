import '../imports.dart';

class JournalEntryNew {
  int rate;
  String title;
  String body;
  String date;

  void setTitle(title) {
    title = title;
  }

  void setBody(body) {
    body = body;
  }

  void setdateTime(date) {
    date = date;
  }

  void setRating(rate) {
    rate = rate;
  }

  String toString() => "Title: $title, Body: $body, Date: $date, Rating: $rate";
}
