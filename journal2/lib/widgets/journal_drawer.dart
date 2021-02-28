import '../imports.dart';

class ThemeDrawer extends StatefulWidget {
  final body;
  final floatingActionButton;
  String title;
  final modifier;
  final state;

  ThemeDrawer(
      {Key key,
      @required this.body,
      this.floatingActionButton,
      this.title,
      this.modifier,
      this.state})
      : super(key: key);

  @override
  _ThemeDrawer createState() => _ThemeDrawer();
}

class _ThemeDrawer extends State<ThemeDrawer> {
  bool darkTheme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //back button
            Navigator.of(context)
                .maybePop(); //maybepop (only pops if there is a page to pop to, otherwise do nothing)
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          )
        ],
      ),
      endDrawer: Drawer(
          //drawer holding the settings (dark mode button)
          child: ListView(
        children: <Widget>[
          Container(
            height: 60,
            child: DrawerHeader(
              child: Text('Settings',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text('Dark Mode',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Align(
                    alignment: Alignment.center,
                    child: Switch(
                        value: widget.state,
                        onChanged: (value) {
                          widget.modifier(value);
                        }))
              ],
            ),
          )
        ],
      )),
      floatingActionButton: hasFloatingActionButton(),
      body: widget.body,
    );
  }

  hasFloatingActionButton() {
    return widget.floatingActionButton ?? Container();
  }

  void newEntryPage(BuildContext context) {
    Navigator.of(context).pushNamed('/formButton');
  }
}
