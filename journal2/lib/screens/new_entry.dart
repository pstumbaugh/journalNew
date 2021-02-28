import '../imports.dart';

class NewEntry extends StatelessWidget {
  static const route = '//new_journal_entry_form';

  final data;
  final state;
  final modifier;

  NewEntry({Key key, this.data, this.state, this.modifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JournalScaffold(
      title: data.date,
      state: state,
      modifier: modifier,
      body: EntryDisplay(data: data),
    );
  }
}
