import 'package:intl/intl.dart';

import '../imports.dart';

class EntryForm extends StatefulWidget {
  final entry = JournalEntry();
  final entryInput = JournalEntryNew();
  final modifier;

  EntryForm({Key key, this.modifier}) : super(key: key);

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            newTextEntry(label: 'Title'),
            newTextEntry(label: 'Body'),
            newIntEntry(label: 'Rating (1-4)'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                form_button(
                    //cancel button - goes back to page before (pop)
                    label: "Cancel",
                    color: Colors.grey[600],
                    pressFunc: () {
                      Navigator.of(context).pop();
                    }),
                form_button(
                    label: "Save",
                    color: Colors.grey[600],
                    pressFunc: () {
                      pressSave();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget newTextEntry({label}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: TextFormField(
        autovalidate: false,
        autofocus: true,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        onSaved: (val) {
          switch (label) {
            case ('Title'):
              widget.entryInput.title = val;
              break;
            case ('Body'):
              widget.entryInput.body = val;
              break;
          }
        },
        validator: (val) {
          return isValidText(val: val, label: label);
        },
      ),
    );
  }

  Widget newIntEntry({label}) {
    String dropdownValue = label;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        onSaved: (val) {
          int value = int.tryParse(val);
          widget.entryInput.rate = value;
        },
        validator: (val) {
          return isValidInt(val: val, label: label);
        },
      ),
    );
  }

  Widget form_button({label, pressFunc, color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 7, 15, 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        onPressed: pressFunc,
        splashColor: Colors.blue,
        child: Text(label, style: TextStyle(color: Colors.white)),
        color: color,
      ),
    );
  }

  String isValidText({val, label}) {
    if (val.isEmpty) {
      return "Please input $label";
    } else {
      return null;
    }
  }

  String isValidInt({val, label}) {
    if (val.isEmpty) {
      return "Please input $label";
    }
    int value = int.tryParse(val);
    if (value < 1 || value > 4) {
      return 'Please input $label 1 ~ 4';
    } else {
      return null;
    }
  }

  void defDate() {
    var formatting = DateFormat('EEEE, MMMM d, y');
    widget.entryInput.date = formatting.format(DateTime.now());
  }

  void pressSave() {
    if (_formkey.currentState.validate()) {
      defDate();
      final dbManager = DatabaseManager.getInstance();

      _formkey.currentState.save();
      dbManager.saveJournalEntry(entry: widget.entryInput);
      widget.modifier(JournalEntry(
        body: widget.entryInput.body,
        title: widget.entryInput.title,
        rate: widget.entryInput.rate,
        date: widget.entryInput.date,
      ));

      Navigator.of(context).pop();
    }
  }
}
