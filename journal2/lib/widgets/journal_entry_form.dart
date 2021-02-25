import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../db/db_manager.dart';
import '../db/journal_entry_dto.dart';

import '../models/jorunal_entry.dart';

class EntryForm extends StatefulWidget {
  final entry = JournalEntry();
  final entryInput = JournalEntryDTO();
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
            entryFieldText(label: 'Title'),
            entryFieldText(label: 'Body'),
            entryFieldInt(label: 'Rating'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                form_button(
                    label: "Cancel",
                    color: Colors.grey[600],
                    pressFunc: () {
                      Navigator.of(context).pop();
                    }),
                form_button(
                    label: "Save",
                    color: Colors.grey,
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

  Widget entryFieldText({label}) {
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

  Widget entryFieldInt({label}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: TextFormField(
        autovalidate: false,
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
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        onPressed: pressFunc,
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
    print(value);
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
