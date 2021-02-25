import '../models/jorunal_entry.dart';

class Journal {
  List<JournalEntry> entries = [];

  Journal({this.entries});

  void addEntry(entry) {
    entries == null ? entries = [entry] : entries.add(entry);
  }
}
