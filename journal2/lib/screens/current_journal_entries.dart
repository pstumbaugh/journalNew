import '../imports.dart';

class JournalEntries extends StatefulWidget {
  static const route = '/';

  String title = 'Welcome';
  final modifier;
  final state;

  JournalEntries({Key key, this.modifier, this.state}) : super(key: key);

  @override
  _JournalEntriesState createState() => _JournalEntriesState();
}

class _JournalEntriesState extends State<JournalEntries> {
  Journal journal;

  @override
  void initState() {
    super.initState();
    entryLoad();
  }

  entryLoad() async {
    final dbManager = DatabaseManager.getInstance();
    List<JournalEntry> recordedData = await dbManager.entries();

    if (recordedData.isNotEmpty) {
      setState(() {
        journal = Journal(entries: recordedData);
        widget.title = 'Journal Entries';
      });
    }
  }

  final lists = List<Map>.generate(200, (index) {
    return {
      'title': 'Journal entry $index',
      'subtitle': 'Subtitle text $index'
    };
  });

  void newEntry(BuildContext context) {
    Navigator.of(context)
        .pushNamed('/new_journal_entry_form', arguments: journalUpdate);
  }

  void entryPage(BuildContext context, JournalEntry data) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewEntry(data: data)));
  }

  void journalUpdate(entry) {
    journal ??= Journal();
    setState(() {
      journal.addEntry(entry);
    });
  }

  String titleChange() {
    if (journal == null) {
      widget.title = 'Welcome';
      return widget.title;
    } else {
      widget.title = 'Journal Entries';
      return widget.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return JournalScaffold(
        title: titleChange(),
        state: widget.state,
        modifier: widget.modifier,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              newEntry(context);
            },
            child: Icon(Icons.add)),
        body: LayoutBuilder(builder: layoutDecider));
  }

  Widget itemList(BuildContext context, card) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return buildEntryCard(context, index, card);
        },
        itemCount: journal.entries.length);
  }

  Widget buildEntryCard(BuildContext context, index, card) {
    return GestureDetector(
        child: card(index),
        onTap: () {
          entryPage(context, journal.entries[index]);
        });
  }

  Widget cardSmall(index) {
    return Card(
      child: ListTile(
        title: Text(
          "${journal.entries[index].title}",
          style: Styles.title1,
        ),
        subtitle: Text('${journal.entries[index].date}', style: Styles.title2),
      ),
    );
  }

  Widget cardLarge(index) {
    return Padding(
      padding: const EdgeInsets.only(right: 40, left: 40, top: 10),
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(children: <Widget>[
                  Text(
                    "${journal.entries[index].title}",
                    style: Styles.title1,
                  ),
                  Text('${journal.entries[index].date}', style: Styles.title2),
                ]),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: EntryDisplay(data: journal.entries[index])),
          ],
        ),
      ),
    );
  }

  Widget dbIsEmpty(context, cardFunc) {
    if (journal == null) {
      return Welcome();
    } else {
      return itemList(context, cardFunc);
    }
  }

  Widget layoutDecider(BuildContext context, BoxConstraints constraints) {
    return constraints.maxWidth < 800
        ? dbIsEmpty(context, cardSmall)
        : dbIsEmpty(context, cardLarge);
  }
}
