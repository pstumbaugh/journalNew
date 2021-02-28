import '../imports.dart';

class NewJournalEntryForm extends StatelessWidget {
  static const route = '/new_journal_entry_form';

  final title = 'New Journal Entry';
  final state;
  final modifier;

  NewJournalEntryForm({Key key, this.state, this.modifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final journalModifier = ModalRoute.of(context).settings.arguments;
    return JournalScaffold(
      modifier: modifier,
      state: state,
      title: title,
      body: EntryForm(modifier: journalModifier),
    );
  }
}
