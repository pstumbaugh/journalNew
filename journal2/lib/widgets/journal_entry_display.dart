import '../imports.dart';

class EntryDisplay extends StatelessWidget {
  final data;

  EntryDisplay({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(data.title, style: Styles.journalTitle), //title
        Text(data.body, style: Styles.cursive), //body
      ],
    );
  }
}
