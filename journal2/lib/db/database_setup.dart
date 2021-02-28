import '../imports.dart';

class DatabaseManager {
  static const String DATABASE_FILENAME = 'journal.sqlite3.db';
  static const String CREATE_FILE = 'assets/schema_1.sql.txt';
  static const String SQL_INSERT =
      'INSERT INTO journal_entries(title, body, rating, date) VALUES(?, ?, ?, ?);';
  static const SQL_SELECT = 'SELECT * FROM journal_entries';

  static DatabaseManager _instance;

  final Database db;

  DatabaseManager._({Database database}) : db = database;

  factory DatabaseManager.getInstance() {
    assert(_instance != null);
    return _instance;
  }

  static Future initalize() async {
    String createSchema = await readQuery();

    final db = await openDatabase(DATABASE_FILENAME, version: 1,
        onCreate: (Database db, int version) async {
      createTables(db, createSchema);
    });
    _instance = DatabaseManager._(database: db);
  }

  static void createTables(Database db, String sql) async {
    await db.execute(sql);
  }

  static Future<String> readQuery() async {
    return await rootBundle.loadString(CREATE_FILE);
  }

  void saveJournalEntry({entry}) {
    db.transaction((txn) async {
      await txn.rawInsert(
          SQL_INSERT, [entry.title, entry.body, entry.rate, entry.date]);
    });
  }

  Future<List<JournalEntry>> entries() async {
    final journalRecords = await db.rawQuery(SQL_SELECT);
    List<JournalEntry> journalEntries = journalRecords.map((record) {
      return JournalEntry(
          title: record['title'],
          body: record['body'],
          rate: record['rating'],
          date: record['date']);
    }).toList();

    return journalEntries;
  }
}
