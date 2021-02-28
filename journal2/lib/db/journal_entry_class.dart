import '../imports.dart';

class JournalEntryNew {
  int rate;
  String title;
  String body;
  String date;

//setters to set the variable in our entry
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

//saves all as a string
  String toString() => "Title: $title, Body: $body, Date: $date, Rating: $rate";
}
