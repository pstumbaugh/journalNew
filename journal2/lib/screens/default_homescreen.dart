import '../imports.dart';

class Welcome extends StatefulWidget {
  @override
  _default_home createState() => _default_home();
}

class _default_home extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Icon(Icons.book, size: 100)),
            Text('Journal'),
          ])),
    );
  }
}
