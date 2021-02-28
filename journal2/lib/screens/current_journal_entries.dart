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
    initializeJournalEntries();
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

  initializeJournalEntries() async {
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

//adding a new entry
  void journalUpdate(entry) {
    journal ??= Journal();
    setState(() {
      journal.addEntry(entry);
    });
  }

//change the title in the AppBar to Journal Entries
  String titleChange() {
    if (journal == null) {
      widget.title = 'Welcome';
      return widget.title;
    } else {
      widget.title = 'Journal Entries';
      return widget.title;
    }
  }

//items in our journal
  Widget itemList(BuildContext context, card) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return buildCard(context, index, card);
        },
        itemCount: journal.entries.length);
  }

//build a new entry
  Widget buildCard(BuildContext context, index, card) {
    return GestureDetector(
        child: card(index),
        onTap: () {
          entryPage(context, journal.entries[index]);
        });
  }

  Widget screenSize1(index) {
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

  Widget screenSize2(index) {
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
        ? dbIsEmpty(context, screenSize1)
        : dbIsEmpty(context, screenSize2);
  }
}
